# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit ecm cmake

DESCRIPTION="xrdesktop effect for KWin."
HOMEPAGE="https://gitlab.freedesktop.org/xrdesktop/kwin-effect-xrdesktop"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://gitlab.freedesktop.org/xrdesktop/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://gitlab.freedesktop.org/xrdesktop/${PN}/-/archive/${PV}/${P}.zip"
	KEYWORDS="~amd64 ~arm64 ~x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE=""
REQUIRED_USE=""

DEPEND="
	media-libs/graphene
	media-libs/xrdesktop
	x11-libs/libinputsynth
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	virtual/pkgconfig
"
src_prepare() {
	eapply "${FILESDIR}/vrmirror.patch"
	eapply_user
	
	cmake_src_prepare
	}
