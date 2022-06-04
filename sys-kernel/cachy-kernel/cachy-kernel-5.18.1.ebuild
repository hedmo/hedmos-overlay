# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit kernel-build toolchain-funcs

MY_P=linux-${PV}-cachy
GENPATCHES_P=genpatches-${PV%.*}-$(( ${PV##*.} + 2 ))
GENTOO_CONFIG_VER=g1

DESCRIPTION="Linux TT scheduler Kernel by CachyOS with Gentoo patches,other patches and improvements"
HOMEPAGE="https://www.kernel.org/ https://xanmod.org/"
SRC_URI+="
	https://github.com/CachyOS/linux/archive/refs/tags/linux-cachyos-tt-${PV}.tar.gz
		-> ${MY_P}.tar.gz
	https://github.com/hedmo/stuff/blob/55610a02491a0142d1e35ed3a09ab2538a79c7af/dot_files/.cachy.config
	https://dev.gentoo.org/~mpagano/dist/genpatches/${GENPATCHES_P}.base.tar.xz
	https://dev.gentoo.org/~mpagano/dist/genpatches/${GENPATCHES_P}.extras.tar.xz
	https://github.com/mgorny/gentoo-kernel-config/archive/${GENTOO_CONFIG_VER}.tar.gz
		-> gentoo-kernel-config-${GENTOO_CONFIG_VER}.tar.gz
"
S=${WORKDIR}/${MY_P}
SLOT="${PV}"

LICENSE="GPL-2"
KEYWORDS="-* ~amd64"
IUSE="debug hardened"

RDEPEND="
	!sys-kernel/cachy-kernel-bin:${SLOT}
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

src_unpack() {

cd "${WORKDIR}" || die
	unpack linux-${PV}-cachy.tar.gz
	
	# We want to rename the unpacked directory to a nice normalised string
	# bug #762766
	mv linux-linux-cachyos-tt${PV} ${MY_P} || die "Unable to move source tree to ${MY_P}."

}

src_prepare() {
	# Remove linux-stable patches (see 0000_README)
	find "${WORKDIR}" -maxdepth 1 -name "1[0-4][0-9][0-9]*.patch" | xargs rm || die

	local PATCHES=(
		# meh, genpatches have no directory
		"${WORKDIR}"/*.patch
	)
	default

	# prepare the default config
	case ${ARCH} in
		amd64)
			cp "${DISTDIR}/.cachy.config" .config || die
			;;
		*)
			die "Unsupported arch ${ARCH}"
			;;
	esac

	rm "${S}/localversion" || die
	local myversion="-cachy-dist"
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
