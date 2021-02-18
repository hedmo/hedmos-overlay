# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
K_WANT_GENPATCHES="base extras"
K_GENPATCHES_VER="1"
K_SECURITY_UNSUPPORTED="1"
K_NOSETEXTRAVERSION="1"
ETYPE="sources"
inherit kernel-2
detect_version

DESCRIPTION="Full XanMod sources with cacule option and including the Gentoo patchset "
HOMEPAGE="https://xanmod.org"
LICENSE+=" CDDL"
KEYWORDS="~amd64"
IUSE="cacule experimental"
XANMOD_VERSION="1"
XANMOD_URI="https://github.com/xanmod/linux/releases/download/"
SRC_URI="
	${KERNEL_BASE_URI}/linux-${KV_MAJOR}.${KV_MINOR}.tar.xz
	cacule? ( ${XANMOD_URI}/${OKV}-xanmod${XANMOD_VERSION}-cacule/patch-${OKV}-xanmod${XANMOD_VERSION}-cacule.xz  )
	!cacule? ( ${XANMOD_URI}/${OKV}-xanmod${XANMOD_VERSION}/patch-${OKV}-xanmod${XANMOD_VERSION}.xz  )
	experimental? ( https://github.com/smeso/sara/releases/download/SARAv6/sara-4.14.y.patch )
	${GENPATCHES_URI}
"

src_unpack() {
UNIPATCH_LIST_DEFAULT=""
	if use cacule; then
		UNIPATCH_LIST="${DISTDIR}/patch-${OKV}-xanmod${XANMOD_VERSION}-cacule.xz "
	else
		UNIPATCH_LIST="${DISTDIR}/patch-${OKV}-xanmod${XANMOD_VERSION}.xz "
	fi
	kernel-2_src_unpack
}

src_prepare() {

	if use cacule; then
		eapply "${FILESDIR}/localversion.patch"
	fi

	if use experimental ; then
		eapply "${DISTDIR}/sara-4.14.y.patch"
	fi

	kernel-2_src_prepare

	rm "${S}"/.config || die

}

pkg_postinst() {
	elog "MICROCODES"
	elog "Use xanmod-sources with microcodes"
	elog "Read https://wiki.gentoo.org/wiki/Intel_microcode"
}
