# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
K_SECURITY_UNSUPPORTED="1"
K_NOSETEXTRAVERSION="1"
ETYPE="sources"
inherit kernel-2
detect_version

DESCRIPTION="A general-purpose kernel with custom settings and new features"
HOMEPAGE="https://xanmod.org"
LICENSE+=" CDDL"
KEYWORDS="~amd64"
XANMOD_VERSION="1"
CACHY_URI="https://raw.githubusercontent.com/hedmo/cachy-sched/master/patches/Cachy/v5.9/cachy-5.9-r8.patch"
LTO_URI="https://gist.githubusercontent.com/hedmo/71324532409a8d6dc1005f5d8b80cced/raw/5dec03184b759184d9aa2ed981eac26bd4defe11/5.8-lto.patch"
IUSE="lto cachy"
SRC_URI="${KERNEL_BASE_URI}/linux-${KV_MAJOR}.${KV_MINOR}.tar.xz https://github.com/xanmod/linux/releases/download/${OKV}-xanmod${XANMOD_VERSION}/patch-${OKV}-xanmod${XANMOD_VERSION}.xz ${GENPATCHES_URI}
( ${LTO_URI} )
( ${CACHY_URI} )
"

UNIPATCH_LIST_DEFAULT=""
UNIPATCH_LIST="${DISTDIR}/patch-${OKV}-xanmod${XANMOD_VERSION}.xz"

src_prepare() {

	if use lto; then
		eapply "${DISTDIR}/5.8-lto.patch"
	fi

	if use cachy; then
		eapply "${DISTDIR}/cachy-5.9-r8.patch"
	fi

	kernel-2_src_prepare

	rm "${S}"/.config || die

}

pkg_postinst() {
	elog "MICROCODES"
	elog "Use xanmod-sources with microcodes"
	elog "Read https://wiki.gentoo.org/wiki/Intel_microcode"
}
