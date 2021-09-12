# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake gnome2-utils xdg flag-o-matic

DESCRIPTION="Maliit keyboard"
HOMEPAGE="https://github.com/maliit/keyboard"

if [[ ${PV} == 9999 ]]; then
		EGIT_REPO_URI="https://github.com/maliit/keyboard.git"
inherit git-r3
else
		SRC_URI="https://github.com/maliit/keyboard/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
		KEYWORDS="~amd64 ~arm"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="test"

DEPEND="x11-misc/maliit-framework
		media-fonts/noto-emoji
		dev-qt/qtmultimedia
		app-text/hunspell
		app-i18n/libchewing
		app-i18n/libpinyin
		app-i18n/anthy
		dev-db/sqlite
"
RDEPEND="${DEPEND}"

BDEPEND="app-doc/doxygen
		media-gfx/graphviz
"

src_prepare() {
	cmake-utils_src_prepare
}

src_configure() {
	# code is not C++17 ready
	append-cxxflags -std=c++14

	local mycmakeargs=(
		-Denable-tests=$(usex test ON OFF)
	)

	cmake-utils_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
