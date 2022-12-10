# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit kernel-build toolchain-funcs

#MY_P=linux-${PV}-xanmod1
MY_P=linux-${PV%.*}
GENPATCHES_P=genpatches-${PV%.*}-$(( ${PV##*.} - 0 ))
CONFIG_VER=5.19.13-gentoo
GENTOO_CONFIG_VER=g3

DESCRIPTION="Linux kernel based on gentoo with powersave (TT) pach and more"
HOMEPAGE="https://www.kernel.org/ https://xanmod.org/"
HEDMOS_URI="raw.githubusercontent.com/hedmo/stuff/main/patches"
COMMIT="510939f83c4c8ce4cb4d3e1e0aae62676eba2c8c"
SRC_URI="
	https://dev.gentoo.org/~mpagano/dist/genpatches/${GENPATCHES_P}.base.tar.xz
	https://dev.gentoo.org/~mpagano/dist/genpatches/${GENPATCHES_P}.extras.tar.xz
	https://github.com/mgorny/gentoo-kernel-config/archive/${GENTOO_CONFIG_VER}.tar.gz
		-> gentoo-kernel-config-${GENTOO_CONFIG_VER}.tar.gz
	https://${HEDMOS_URI}/hedmos-patches.tar.gz
	amd64? (
	https://cdn.kernel.org/pub/linux/kernel/v$(ver_cut 1).x/${MY_P}.tar.xz
	https://src.fedoraproject.org/rpms/kernel/raw/rawhide/f/kernel-x86_64-fedora.config
			-> kernel-x86_64-fedora.config.${CONFIG_VER}
	)
	arm? (	https://github.com/clamor-s/linux/archive/${COMMIT}.tar.gz
		-> ${MY_P}.tar.gz
	https://cdn.kernel.org/pub/linux/kernel/v$(ver_cut 1).x/patch-${PV}.xz
	)
"
	case ${ARCH} in
		amd64)
			S=${WORKDIR}/${MY_P}
			;;
		arm)
		S=${WORKDIR}/linux-${COMMIT}
			;;
	esac

LICENSE="GPL-2"
KEYWORDS="~arm ~amd64"
IUSE="+anbox ddci debug +futex hardened tt"
REQUIRED_USE="
		arm? ( savedconfig !tt )
"
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
	# Remove linux-stable patches lower then Clamors rebase.
	case ${ARCH} in
		amd64)
			eapply "${WORKDIR}/hedmos-patches/graysky/"*.patch
			;;
		arm)
		find "${WORKDIR}" -maxdepth 1 -name "1[0-4][0-5][0-5]*.patch" -exec rm {} + || die
#		find "${WORKDIR}" -maxdepth 1 -name "2010_netfilter-ctnetlink-compilation-fix.patch" -exec rm {} + || die
			;;
	esac

	# meh, genpatches have no directory
	#patching main patches before TT
		eapply "${WORKDIR}"/*.patch

	if use ddci; then
		eapply "${WORKDIR}/hedmos-patches/ddci/"*.patch
	fi
	if use tt; then
		eapply "${WORKDIR}/hedmos-patches/TT/"*.patch
	fi
	if use anbox; then
		eapply "${WORKDIR}/hedmos-patches/android_anbox/"*.patch
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
		arm)
			return
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
