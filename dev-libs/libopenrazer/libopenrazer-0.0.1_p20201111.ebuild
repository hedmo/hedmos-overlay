# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="Razer devices lib"
HOMEPAGE="https://github.com/z3ntu/libopenrazer"
if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/z3ntu/${PN}.git"
	inherit git-r3
else
	COMMIT="1829dabd8c4d2a80b4323d4794d9990757feb6b8"
	SRC_URI="https://github.com/z3ntu/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
	KEYWORDS=" ~amd64 "
	S="${WORKDIR}"/${PN}-${COMMIT}
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="demo"

DEPEND="
	dev-qt/qtdbus:5
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtxml:5"
RDEPEND="${DEPEND}"
BDEPEND="
	virtual/pkgconfig"

src_configure() {
	local emesonargs=(
		"$(meson_use demo demo)"
	)
	meson_src_configure
}
