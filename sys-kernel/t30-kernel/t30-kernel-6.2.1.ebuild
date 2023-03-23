# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit kernel-build toolchain-funcs

MY_P=linux-${PV}
GENPATCHES_P=genpatches-${PV%.*}-$(( ${PV##*.} + 1 ))
GENTOO_CONFIG_VER=g3

DESCRIPTION="Clamors fork of :grate-driver/linux with gentoo patches"
HOMEPAGE="https://github.com/grate-driver/linux"
COMMIT="913001534026ccd7817fd1e1a816c8b0bd16df7e"
SRC_URI+="
	https://dev.gentoo.org/~alicef/dist/genpatches/${GENPATCHES_P}.base.tar.xz
	https://dev.gentoo.org/~alicef/dist/genpatches/${GENPATCHES_P}.extras.tar.xz
	https://github.com/mgorny/gentoo-kernel-config/archive/${GENTOO_CONFIG_VER}.tar.gz
		-> gentoo-kernel-config-${GENTOO_CONFIG_VER}.tar.gz

	https://github.com/hedmo/linux-clamor/archive/${COMMIT}.tar.gz
		-> ${MY_P}.tar.gz
	https://raw.githubusercontent.com/clamor-s/linux/510939f83c4c8ce4cb4d3e1e0aae62676eba2c8c/arch/arm/configs/transformer_defconfig
"
S=${WORKDIR}/linux-${COMMIT}
SLOT="${PV}"

LICENSE="GPL-2"
KEYWORDS="~arm"
IUSE="debug hardened"
REQUIRED_USE="
"
RDEPEND="
	!sys-kernel/t30-kernel-bin:${SLOT}
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
		#find "${WORKDIR}" -maxdepth 1 -name "1[0-4][0-5][0-5]*.patch" -exec rm {} + || die
		local PATCHES=(
		# meh, genpatches have no directory
		"${WORKDIR}"/*.patch
	)

	default

	# prepare the default config
	case ${ARCH} in
		arm)
			cp "${DISTDIR}/"transformer_defconfig .config || die
			;;
		*)
			die "Unsupported arch ${ARCH}"
			;;
	esac

	local myversion="-t30-dist"
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
