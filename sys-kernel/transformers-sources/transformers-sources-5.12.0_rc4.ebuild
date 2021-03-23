# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

ETYPE=sources
K_DEFCONFIG="tegra_defconfig"
K_SECURITY_UNSUPPORTED=1
EXTRAVERSION="-${PN}/-*"
inherit kernel-2
detect_version
detect_arch

inherit git-r3 eapi7-ver
EGIT_REPO_URI=" https://github.com/grate-driver/linux.git -> transformers-linux.git"
EGIT_BRANCH="master"
GIT_COMMIT="448606fc7353d05417c84c4c7cf5139d2e6f40d6"
EGIT_CHECKOUT_DIR="${WORKDIR}/linux-${PV/_/-}-transformers"
EGIT_CLONE_TYPE="shallow"

DESCRIPTION="Asus Transformers pad kernel sources"
HOMEPAGE="https://github.com/grate-driver/linux.git"

KEYWORDS=""
src_unpack() {
	git-r3_src_unpack
	unpack_set_extraversion
}
