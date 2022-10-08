# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit kernel-build toolchain-funcs

MY_P=linux-${PV%.*}
# https://dev.gentoo.org/~mpagano/genpatches/index.html
GENPATCHES_P=genpatches-${PV%.*}-$(( ${PV##*.} + 1 ))
CONFIG_VER=5.17.7
# Commit hash from https://src.fedoraproject.org/rpms/kernel
CONFIG_HASH=f20aa9d1023a1912c5ef522d47b7deab27fae207
# Tag from https://github.com/mgorny/gentoo-kernel-config
GENTOO_CONFIG_VER=g1

DESCRIPTION="Linux kernel built with XanMod and Gentoo patches"
HOMEPAGE="https://www.kernel.org/ https://xanmod.org/"
TT_URI="https://raw.githubusercontent.com/hedmo/stuff/main/patches"
SRC_URI+="
	https://cdn.kernel.org/pub/linux/kernel/v$(ver_cut 1).x/${MY_P}.tar.xz
	https://github.com/xanmod/linux/releases/download/${PV}-xanmod1/patch-${PV}-xanmod1.xz
	https://dev.gentoo.org/~mpagano/dist/genpatches/${GENPATCHES_P}.base.tar.xz
	https://dev.gentoo.org/~mpagano/dist/genpatches/${GENPATCHES_P}.extras.tar.xz
	https://github.com/mgorny/gentoo-kernel-config/archive/${GENTOO_CONFIG_VER}.tar.gz
		-> gentoo-kernel-config-${GENTOO_CONFIG_VER}.tar.gz
	amd64? (
		https://src.fedoraproject.org/rpms/kernel/raw/${CONFIG_HASH}/f/kernel-x86_64-fedora.config
			-> kernel-x86_64-fedora.config.${CONFIG_VER}
	)
		tt? (
		${TT_URI}/0001-tt-5.19.patch
	)
"
S=${WORKDIR}/${MY_P}

LICENSE="GPL-2"
KEYWORDS="-* ~amd64"
IUSE="debug hardened tt"

RDEPEND="
	!sys-kernel/xanmod-kernel-bin:${SLOT}
"
BDEPEND="
	debug? ( dev-util/pahole )
"
PDEPEND="
	>=virtual/dist-kernel-${PV}
"

QA_FLAGS_IGNORED="
	usr/src/linux-.*/scripts/gcc-plugins/.*.so
	usr/src/linux-.*/vmlinux
"

src_prepare() {
	# Remove linux-stable patches (see 0000_README)
	find "${WORKDIR}" -maxdepth 1 -name "1[0-4][0-9][0-9]*.patch" | xargs rm || die


	if use tt; then
		eapply "${DISTDIR}/0001-tt-5.19.patch"
	fi

	local PATCHES=(
		# meh, genpatches have no directory
		"${WORKDIR}"/*.patch
		"${WORKDIR}"/patch-${PV}-xanmod1
	)
	default

	# prepare the default config
	case ${ARCH} in
		amd64)
			cp "${DISTDIR}/kernel-x86_64-fedora.config.${CONFIG_VER}" .config || die
			;;
		*)
			die "Unsupported arch ${ARCH}"
			;;
	esac

	rm "${S}/localversion" || die
	local myversion="-xanmod1-dist"
	use hardened && myversion+="-hardened"
	echo "CONFIG_LOCALVERSION=\"${myversion}\"" > "${T}"/version.config || die
	local dist_conf_path="${WORKDIR}/gentoo-kernel-config-${GENTOO_CONFIG_VER}"

	local merge_configs=(
		"${T}"/version.config
		"${dist_conf_path}"/base.config
	)
	use debug || merge_configs+=(
		"${dist_conf_path}"/no-debug.config
	)
	if use hardened; then
		merge_configs+=( "${dist_conf_path}"/hardened-base.config )

		tc-is-gcc && merge_configs+=( "${dist_conf_path}"/hardened-gcc-plugins.config )

		if [[ -f "${dist_conf_path}/hardened-${ARCH}.config" ]]; then
			merge_configs+=( "${dist_conf_path}/hardened-${ARCH}.config" )
		fi
	fi

	kernel-build_merge_configs "${merge_configs[@]}"
}