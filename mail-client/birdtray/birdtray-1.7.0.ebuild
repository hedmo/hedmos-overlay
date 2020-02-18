# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils git-r3 xdg-utils

DESCRIPTION="Birdtray is a free system tray notification for new mail for Thunderbird"
HOMEPAGE="https://github.com/gyunaev/birdtray"
EGIT_REPO_URI="https://github.com/gyunaev/${PN}"
EGIT_COMMIT="d5f718d944df0455e9bff156cc4f85208e391411"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-db/sqlite
	dev-qt/qtcore:5=
	dev-qt/qtx11extras:5=
	"

src_install() {
	dobin  "${BUILD_DIR}/${PN}"
}

pkg_postinst() {
	xdg_icon_cache_update
}
pkg_postrm() {
	xdg_icon_cache_update
}
