# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KERNEL_IUSE_MODULES_SIGN=1
inherit kernel-build toolchain-funcs

#MY_P=linux-${PV}-xanmod1
MY_P=linux-${PV%.*}
GENPATCHES_P=genpatches-${PV%.*}-$(( ${PV##*.} +2 ))
CONFIG_VER=5.19.13-gentoo
GENTOO_CONFIG_VER=g3

DESCRIPTION="Linux kernel based on gentoo with powersave (TT) pach and more"
HOMEPAGE="https://github.com/hedmo/hedmos-overlay.git"
HEDMOS_URI="raw.githubusercontent.com/hedmo/stuff/main/patches"
SRC_URI="
	https://dev.gentoo.org/~mpagano/dist/genpatches/${GENPATCHES_P}.base.tar.xz
	https://dev.gentoo.org/~mpagano/dist/genpatches/${GENPATCHES_P}.extras.tar.xz
	https://github.com/mgorny/gentoo-kernel-config/archive/${GENTOO_CONFIG_VER}.tar.gz
		-> gentoo-kernel-config-${GENTOO_CONFIG_VER}.tar.gz
	https://${HEDMOS_URI}/hedmos-patches.tar.gz
	https://cdn.kernel.org/pub/linux/kernel/v$(ver_cut 1).x/${MY_P}.tar.xz
	https://src.fedoraproject.org/rpms/kernel/raw/rawhide/f/kernel-x86_64-fedora.config
			-> kernel-x86_64-fedora.config.${CONFIG_VER}
	https://raw.githubusercontent.com/CachyOS/kernel-patches/master/6.5/sched/0001-tt.patch
"
S=${WORKDIR}/${MY_P}

LICENSE="GPL-2"
KEYWORDS="~amd64"
IUSE="ddci debug +futex hardened tt"


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

	# meh, genpatches have no directory
	#patching main patches before TT
		eapply "${WORKDIR}"/*.patch
		eapply "${WORKDIR}/hedmos-patches/graysky/"*.patch

	if use ddci; then
		eapply "${WORKDIR}/hedmos-patches/ddci/"*.patch
	fi
	if use tt; then
		eapply "${DISTDIR}/0001-tt.patch"
	fi
	if use futex ; then
		eapply "${WORKDIR}/hedmos-patches/futex/"*.patch
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
