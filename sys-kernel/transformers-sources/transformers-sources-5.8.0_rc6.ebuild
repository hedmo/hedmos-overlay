# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

ETYPE=sources
K_DEBLOB_AVAILABLE=1
K_DEFCONFIG="tf300_defconfig"
K_SECURITY_UNSUPPORTED=1
EXTRAVERSION="-${PN}/-*"
inherit kernel-2
detect_version
detect_arch

inherit git-r3 eapi7-ver
SRC_URI=" https://github.com/grate-driver/linux/archive/24a7a99f2e5fee99e09f1e7a71ecb31034770059.zip
https://linux-libre.fsfla.org/pub/linux-libre/releases/5.8-rc6-gnu/linux-libre-5.8-rc6-gnu.tar.xz"

WORKDIR="${WORKDIR}/linux-${PV/_/-}-transformers"


DESCRIPTION="Asus Transformers pad kernel sources"
HOMEPAGE="https://github.com/grate-driver/linux.git"

KEYWORDS=""
IUSE="deblob"
src_unpack() {
	git-r3_src_unpack
	unpack_set_extraversion
}
