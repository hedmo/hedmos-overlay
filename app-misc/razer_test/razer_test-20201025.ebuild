# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit  meson

DESCRIPTION="A work-in-progress replacement for OpenRazer"
HOMEPAGE="https://github.com/z3ntu/RazerGenie"
if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/z3ntu/${PN}.git"
    inherit git-r3
else
COMMIT="2987c014c6fe95f971ca12c4187c51004a9eeec6"
SRC_URI="https://github.com/z3ntu/${PN}/archive/${COMMIT}.zip"
	KEYWORDS=" ~amd64  ~x86 "
fi
S="${WORKDIR}"/${PN}-${COMMIT}

LICENSE="GPL-3"
SLOT="0"
IUSE="bringup tests"

DEPEND="dev-qt/qtdbus:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5"
RDEPEND="${DEPEND}"
BDEPEND="dev-qt/linguist-tools:5
	virtual/pkgconfig
	dev-libs/hidapi"

src_configure() {
     local emesonargs=(
	    "$(meson_use bringup build_bringup_util)"
	    "$(meson_use tests build_tests)"
     )
	meson_src_configure
}
