# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
K_WANT_GENPATCHES="base extras"
K_GENPATCHES_VER="2"
K_SECURITY_UNSUPPORTED="1"
K_NOSETEXTRAVERSION="1"
ETYPE="sources"
inherit kernel-2
detect_version

DESCRIPTION="Full XanMod sources with tt option and including the Gentoo patchset "
HOMEPAGE="https://xanmod.org"
LICENSE+=" CDDL"
KEYWORDS="~amd64"
IUSE="tt"
XANMOD_VERSION="1"
XANMOD_URI="https://github.com/xanmod/linux/releases/download/"
SRC_URI="
	${KERNEL_BASE_URI}/linux-${KV_MAJOR}.${KV_MINOR}.tar.xz
	tt? ( ${XANMOD_URI}/${OKV}-xanmod${XANMOD_VERSION}-tt/patch-${OKV}-xanmod${XANMOD_VERSION}-tt.xz  )
	!tt? ( ${XANMOD_URI}/${OKV}-xanmod${XANMOD_VERSION}/patch-${OKV}-xanmod${XANMOD_VERSION}.xz  )
	${GENPATCHES_URI}
"

src_unpack() {
UNIPATCH_LIST_DEFAULT=""
	if use tt; then
		UNIPATCH_LIST="${DISTDIR}/patch-${OKV}-xanmod${XANMOD_VERSION}-tt.xz "
	else
		UNIPATCH_LIST="${DISTDIR}/patch-${OKV}-xanmod${XANMOD_VERSION}.xz "
	fi

	kernel-2_src_unpack
}

src_prepare() {

	if use tt; then
		eapply "${FILESDIR}/localversion.patch"
	fi

	kernel-2_src_prepare

}

pkg_postinst() {
	elog "MICROCODES"
	elog "Use xanmod-sources with microcodes"
	elog "Read https://wiki.gentoo.org/wiki/Intel_microcode"
}
