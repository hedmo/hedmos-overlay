# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN^}"
COMMIT="079bd990b78b200216198d58a4df9a5757606726"
if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/nullobsi/${MY_PN}"
	EGIT_BRANCH="master"
	VCS_ECLASS="git-r3"
else
	SRC_URI="https://github.com/nullobsi/${MY_PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-${COMMIT}"
	KEYWORDS="~amd64 ~x86"
fi

inherit cmake xdg-utils ${VCS_ECLASS}

DESCRIPTION="A gui clight that turns your webcam into a light sensor"
HOMEPAGE="https://github.com/nullobsi/clight-gui.git"

LICENSE="GPL-3"
SLOT="0"
IUSE=""

PATCHES=(
	#"${FILESDIR}/clight-gentoo-skip-manpage-compression.patch"
)

DEPEND="
	dev-qt/qtcharts
	dev-qt/qtxml
"

RDEPEND="
	${DEPEND}
	>=app-misc/clight-4.4
"
src_prepare(){
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
