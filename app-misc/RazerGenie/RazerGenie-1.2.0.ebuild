# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="Razer devices configurator"
HOMEPAGE="https://github.com/z3ntu/RazerGenie"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/z3ntu/${PN}.git"
	inherit git-r3
else
	COMMIT=""
	SRC_URI="https://github.com/z3ntu/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS=" ~amd64  "
	S="${WORKDIR}"/${PN}-${PV}
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="+openrazer razer-test matrix"

DEPEND="
	dev-qt/qtdbus:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5"
RDEPEND="${DEPEND}
	razer-test? ( !sys-apps/openrazer )
	>=dev-libs/libopenrazer-0.3.0
	app-misc/razer_test
	x11-themes/hicolor-icon-theme
	dev-qt/linguist-tools:5
	openrazer? ( sys-apps/openrazer )
	"
BDEPEND="
	virtual/pkgconfig
	"


