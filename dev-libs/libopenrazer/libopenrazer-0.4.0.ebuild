# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Razer devices lib"
HOMEPAGE="https://github.com/z3ntu/libopenrazer"
if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/z3ntu/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/z3ntu/${PN}/releases/download/v${PV}/${P}.tar.xz"
	KEYWORDS=" ~amd64 "
	S="${WORKDIR}"/${PN}-${PV}
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="demo"

DEPEND="
	dev-qt/qtnetworkauth:6
"
RDEPEND="${DEPEND}"
BDEPEND="
	virtual/pkgconfig"

src_configure() {
	local emesonargs=(
		"$(meson_use demo demo)"
	)
	meson_src_configure
}
