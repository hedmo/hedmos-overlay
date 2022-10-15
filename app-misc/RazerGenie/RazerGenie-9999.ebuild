# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/z3ntu/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/z3ntu/${PN}/archive/refs/tags/v${PN}.tar.gz"
	KEYWORDS=" ~amd64 "
fi

DESCRIPTION="Razer devices configurator"
HOMEPAGE="https://github.com/z3ntu/RazerGenie"
SRC_URI=""

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="matrix"

DEPEND="
	dev-qt/qtdbus:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5"
RDEPEND="${DEPEND}
	dev-qt/linguist-tools:5
	sys-apps/openrazer [daemon]
	"
BDEPEND="
	virtual/pkgconfig
	"

src_configure() {
	local emesonargs=(
		"$(meson_use matrix include_matrix_discovery)"
	)
	meson_src_configure
}
