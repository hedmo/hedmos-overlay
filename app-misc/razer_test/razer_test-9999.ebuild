# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit  meson

DESCRIPTION="A work-in-progress replacement for OpenRazer"
HOMEPAGE="https://github.com/z3ntu/razer_test"
if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/z3ntu/${PN}.git"
	inherit git-r3
else
	COMMIT="bb609cf0036d95c1afff855f2a5bce8cf4a41c11"
	SRC_URI="https://github.com/z3ntu/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
	KEYWORDS=" ~amd64 "
	S="${WORKDIR}"/${PN}-${COMMIT}
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="bringup tests"

DEPEND="
	dev-qt/qtdbus:5
	dev-qt/qtnetwork:5
	dev-qt/linguist-tools:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	"
RDEPEND="${DEPEND}
	dev-libs/hidapi
	"
BDEPEND="
	virtual/pkgconfig
	dev-libs/hidapi
	"

src_configure() {
	local emesonargs=(
		"$(meson_use bringup build_bringup_util)"
		"$(meson_use tests build_tests)"
	)
	meson_src_configure
}
