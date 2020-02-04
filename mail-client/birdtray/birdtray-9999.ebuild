# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 qmake-utils desktop

DESCRIPTION="Run Thunderbird with a system tray icon."
HOMEPAGE="https://github.com/gyunaev/birdtray"
EGIT_REPO_URI="https://github.com/gyunaev/birdtray"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="dev-qt/qtx11extras:5
	dev-db/sqlite:3"
RDEPEND="${DEPEND}"
BDEPEND=""

src_configure() {
	eqmake5 ./src
}

src_compile() {
	emake
}

src_install() {
	dobin "birdtray"
	domenu "${FILESDIR}/birdtray.desktop"
}
