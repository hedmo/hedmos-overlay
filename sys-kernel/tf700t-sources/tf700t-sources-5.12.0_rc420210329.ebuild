# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

ETYPE=sources
K_DEFCONFIG="tegra3_defconfig"
K_SECURITY_UNSUPPORTED=1
EXTRAVERSION="-${PN}/-*"
inherit kernel-2
detect_version
detect_arch

inherit  eapi7-ver
COMMIT="c1c0020b1593cb3cbdfa415ab618fbe180ac572b"
SRC_URI="https://github.com/clamor95/linux/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
DESCRIPTION="Asus Transformers pad tf700t kernel sources"
HOMEPAGE="https://github.com/clamor95/linux"

KEYWORDS=""

src_unpack() {
	unpack_set_extraversion
}
