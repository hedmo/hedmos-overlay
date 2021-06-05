# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

ETYPE=sources
K_DEFCONFIG="tegra3_defconfig"
K_SECURITY_UNSUPPORTED=1
EXTRAVERSION=""
inherit kernel-2
detect_version
detect_arch

DESCRIPTION="tegra3 kernel sources"
HOMEPAGE="https://github.com/grate-driver/linux"

inherit  eapi7-ver
IUSE="config cacule"
COMMIT="d90b5dc6a13c7e00a8b742dab90632080b55d04f"
EXTRAS_URI="https://raw.githubusercontent.com/hedmo/stuff/main"
SRC_URI="
https://github.com/grate-driver/linux/archive/${COMMIT}.tar.gz -> linux-${KV_FULL}.tar.gz
	config? ( ${EXTRAS_URI}/dot_files/.config-transformers -> .config )
	cacule? ( ${EXTRAS_URI}/patches/clamor-cacule-5.13.patch )
"

KEYWORDS="~arm"

src_unpack() {
	default

	# We want to rename the unpacked directory to a nice normalised string
	# bug #762766
	mv "${WORKDIR}"/linux-${COMMIT} "${WORKDIR}"/linux-${KV_FULL} || die
}

src_prepare() {
default

	#if one wants to use my .config
	if use config; then
	cp "${DISTDIR}"/.config "${WORKDIR}"/linux-${KV_FULL}/ || die
	fi

	if use cacule; then
		eapply "${DISTDIR}/clamor-cacule-5.13.patch" || die
	fi
}
