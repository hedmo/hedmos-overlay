 
 
# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="Razer devices lib"
HOMEPAGE="https://github.com/z3ntu/RazerGenie"
if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/z3ntu/${PN}.git"
    inherit git-r3
else
COMMIT="c1db352b9d7c18e82a6b45be446b42569755231f"
SRC_URI="https://github.com/z3ntu/${PN}/archive/${COMMIT}.zip"
	KEYWORDS=" ~amd64  ~x86 "
S="${WORKDIR}"/${PN}-${COMMIT}
fi


LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND="dev-qt/qtdbus:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5"
RDEPEND="${DEPEND}"
BDEPEND="dev-qt/linguist-tools:5
	virtual/pkgconfig"

src_configure() {
	
	meson_src_configure
}
