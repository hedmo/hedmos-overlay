# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
EGIT_HAS_SUBMODULES=true

inherit cmake-utils eutils git-2

DESCRIPTION="Compiz Window Manager Plugins"
HOMEPAGE="http://www.compiz.org/"
EGIT_REPO_URI="git://github.com/hedmo/compiz-plugins-main.git"
#EGIT_REPO_URI="https://github.com/micove/compiz-fusion-plugins-main"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""



RDEPEND="
	!x11-plugins/compiz-fusion-plugins-main
	>=gnome-base/librsvg-2.14.0
	media-libs/libjpeg-turbo
	x11-libs/cairo
	~x11-wm/compiz-${PV}
	dev-cpp/gtest
	dev-cpp/gmock

"

DEPEND="${RDEPEND}
	>=dev-util/intltool-0.35
	>=dev-util/pkgconfig-0.19
	>=sys-devel/gettext-0.15
"

src_configure() {
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
}
