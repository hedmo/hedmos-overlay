# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit kernel-build toolchain-funcs

#MY_P=linux-${PV}-xanmod1
MY_P=linux-${PV%.*}
GENPATCHES_P=genpatches-${PV%.*}-$(( ${PV##*.} + 0 ))
CONFIG_VER=5.19.13-gentoo
GENTOO_CONFIG_VER=g3

DESCRIPTION="Linux kernel based on gentoo with powersave (TT) pach and more"
HOMEPAGE="https://www.kernel.org/ https://xanmod.org/"
HEDMOS_URI="github.com/hedmo/stuff/raw/main/patches/"
SRC_URI="
	https://cdn.kernel.org/pub/linux/kernel/v$(ver_cut 1).x/${MY_P}.tar.xz
	https://dev.gentoo.org/~mpagano/dist/genpatches/${GENPATCHES_P}.base.tar.xz
	https://dev.gentoo.org/~mpagano/dist/genpatches/${GENPATCHES_P}.extras.tar.xz
	https://github.com/mgorny/gentoo-kernel-config/archive/${GENTOO_CONFIG_VER}.tar.gz
		-> gentoo-kernel-config-${GENTOO_CONFIG_VER}.tar.gz
	https://raw.githubusercontent.com/projg2/fedora-kernel-config-for-gentoo/${CONFIG_VER}/kernel-x86_64-fedora.config
			-> kernel-x86_64-fedora.config.${CONFIG_VER}
	https://${HEDMOS_URI}/hedmos-patches.tar.gz
	p1801? ( https://${HEDMOS_URI}/andy-patches-6.0.x.tar.gz  )
"
S=${WORKDIR}/${MY_P}

LICENSE="GPL-2"
KEYWORDS="-* ~amd64"
IUSE="debug hardened +tt +anbox +futex p1801"

RDEPEND="
	!sys-kernel/hedmos-kernel-bin:${SLOT}
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
#	# Remove linux-stable patches (see 0000_README)
#		find "${WORKDIR}" -maxdepth 1 -name "1[0-4][0-9][0-9]*.patch" -exec rm {} + || die

	# meh, genpatches have no directory
	#patching main patches before TT
		eapply "${WORKDIR}"/*.patch
		eapply "${WORKDIR}/hedmos-patches/graysky/"*.patch

	if use tt; then
		eapply "${WORKDIR}/hedmos-patches/TT/"*.patch
	fi
	if use anbox; then
		eapply "${WORKDIR}/hedmos-patches/android_anbox/"*.patch
	fi
	if use futex; then
		eapply "${WORKDIR}/hedmos-patches/futex/"*.patch
	fi
	if use p1801; then
		eapply "${WORKDIR}/andy-patches/"*.patch
	fi
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

#	rm "${S}/localversion" || die
	local myversion="-hedmo1-dist"
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
