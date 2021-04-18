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

DESCRIPTION="Asus Transformers pad tf700t kernel sources"
HOMEPAGE="https://github.com/clamor95/linux"

inherit  eapi7-ver
IUSE="config cacule"
COMMIT="2f7734c53bdb5f00b30cf28f5513aaa42e2dfac4"
CACULE_URI="https://raw.githubusercontent.com/hamadmarri/cacule-cpu-scheduler/master/patches/CacULE"
EXTRAS_URI="https://raw.githubusercontent.com/hedmo/stuff/main"
SRC_URI="
https://github.com/clamor95/linux/archive/${COMMIT}.tar.gz -> linux-${KV_FULL}.tar.gz
	config? ( ${EXTRAS_URI}/dot_files/.config-transformers -> .config )
	cacule? ( ${CACULE_URI}/v5.12/cacule-5.12.patch )
	cacule? ( ${CACULE_URI}/32bit/cacule-32bit-converter.patch )
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
		eapply "${DISTDIR}/cacule-5.12.patch" || die
		eapply "${DISTDIR}/cacule-32bit-converter.patch" || die
	fi
}
