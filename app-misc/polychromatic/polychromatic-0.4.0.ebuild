# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7

PYTHON_COMPAT=( python{2_7,3_6,3_7} ) # 3.4 needs to be tested


inherit git-r3 python-utils-r1  meson

DESCRIPTION="A graphical front end for managing Razer peripherals under GNU/Linux."
HOMEPAGE="https://github.com/polychromatic/polychromatic/"
EGIT_REPO_URI="https://github.com/polychromatic/polychromatic.git"
EGIT_BRANCH="dev-0.4.0"
EGIT_CLONE_TYPE="shallow"

# TODO: Make use of the python eclass?

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
#IUSE="experimental matrix"

RDEPEND="
	app-misc/openrazer
    dev-ruby/sass
	
	dev-libs/less
	>=dev-lang/python-3.4.5
	dev-python/pygobject
	dev-python/setproctitle
	dev-python/requests

	x11-libs/gtk+[introspection]
	dev-libs/libappindicator:3[introspection]
	net-libs/webkit-gtk[introspection]
"
DEPEND="${RDEPEND}"

src_configure() {
	local emesonargs=(
#		"$(meson_use experimental enable_experimental)"
#		"$(meson_use matrix include_matrix_discovery)"
	)
	meson_src_configure
}
