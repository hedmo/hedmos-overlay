# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8


MY_PN="${PN^}"
COMMIT="29e7216bfcc68135350a695ce446134bcb0463a6"
if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/nullobsi/${MY_PN}"
	EGIT_BRANCH="master"
	VCS_ECLASS="git-r3"
else
	SRC_URI="https://github.com/nullobsi/${MY_PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-${COMMIT}"
	KEYWORDS="~amd64 ~x86"
fi

inherit cmake xdg-utils  ${VCS_ECLASS}

DESCRIPTION="A gui clight that turns your webcam into a light sensor"
HOMEPAGE="https://github.com/nullobsi/clight-gui.git"

LICENSE="GPL-3"
SLOT="0"
IUSE="qt6"

DEPEND="
	dev-qt/qtcharts
	dev-qt/qtxml
"

RDEPEND="
	${DEPEND}
	>=app-misc/clight-4.4
"

src_prepare(){
if use qt6; then
	eapply "${FILESDIR}/qt6.patch"
fi
	cd "${S}/src"
	ls .
	cmake_src_prepare
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
