# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils git-r3 xdg-utils

DESCRIPTION="Run Thunderbird with a system tray icon."
HOMEPAGE="https://github.com/gyunaev/birdtray"
EGIT_REPO_URI="https://github.com/gyunaev/birdtray"

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
