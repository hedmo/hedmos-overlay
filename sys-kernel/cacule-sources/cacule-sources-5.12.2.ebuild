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

DESCRIPTION="cacule patched sources with xanmod option and including the Gentoo patchset "
HOMEPAGE="https://xanmod.org"
LICENSE+=" CDDL"
KEYWORDS="~amd64"
IUSE="xanmod experimental"
XANMOD_VERSION="1"
CACULE_URI="https://raw.githubusercontent.com/hamadmarri/cacule-cpu-scheduler/master/patches/CacULE"

XANMOD_URI="https://github.com/xanmod/linux/releases/download/"
SRC_URI="
	${KERNEL_BASE_URI}/linux-${KV_MAJOR}.${KV_MINOR}.tar.xz
	${CACULE_URI}/v5.12/cacule-5.12.patch
	xanmod? ( ${XANMOD_URI}/${OKV}-xanmod${XANMOD_VERSION}/patch-${OKV}-xanmod${XANMOD_VERSION}.xz  )
	experimental? ( https://github.com/hamadmarri/cacule-cpu-scheduler/files/6383440/select_task_interactive_aware.patch.zip )
	${GENPATCHES_URI}
"

src_unpack() {
UNIPATCH_LIST_DEFAULT=""
	if use xanmod; then
		UNIPATCH_LIST="${DISTDIR}/patch-${OKV}-xanmod${XANMOD_VERSION}.xz "
	fi

	if use experimental; then
		unpack "select_task_interactive_aware.patch.zip"
	fi
	kernel-2_src_unpack
}

src_prepare() {

	eapply "${DISTDIR}/cacule-5.12.patch" || die

	if use experimental ; then
		eapply "${WORKDIR}/select_task_interactive_aware.patch"
	fi

	kernel-2_src_prepare

	if use xanmod ; then
	rm "${S}"/.config || die
	fi
}

pkg_postinst() {
	elog "MICROCODES"
	elog "Use xanmod-sources with microcodes"
	elog "Read https://wiki.gentoo.org/wiki/Intel_microcode"
}
