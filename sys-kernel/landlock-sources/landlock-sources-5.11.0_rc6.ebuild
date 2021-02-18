# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

ETYPE=sources
K_DEFCONFIG=""
K_SECURITY_UNSUPPORTED=1
EXTRAVERSION="-${PN}/-*"
inherit kernel-2
detect_version
detect_arch

inherit git-r3 eapi7-ver
EGIT_REPO_URI="https://github.com/landlock-lsm/linux.git -> landlock-linux.git"
EGIT_BRANCH="master"
GIT_COMMIT="1ea03bba615de59a3282b37e5ec31d14c985e772"
EGIT_CHECKOUT_DIR="${WORKDIR}/linux-${PV/_/-}-landlock"
EGIT_CLONE_TYPE="shallow"

XANMOD_VERSION="1"
XANMOD_URI="https://github.com/xanmod/linux/releases/download/"
OKV="5.11.0"

DESCRIPTION="landlock kernel sources"
HOMEPAGE="https://github.com/landlock-lsm/linux.git"

KEYWORDS=""
IUSE="experimental"
src_unpack() {
	git-r3_src_unpack
	unpack_set_extraversion

UNIPATCH_LIST_DEFAULT=""
	if use experimental; then
		UNIPATCH_LIST="${FILESDIR}/patch-${OKV}-xanmod${XANMOD_VERSION}.xz "
	fi
		kernel-2_src_unpack
}
