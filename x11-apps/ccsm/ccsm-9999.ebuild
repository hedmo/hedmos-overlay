# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit distutils git gnome2-utils

EGIT_REPO_URI="git://compiz.org/compiz/compizconfig/${PN}"

DESCRIPTION="Compizconfig Settings Manager"
HOMEPAGE="http://www.compiz.org/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""
COLLISION_IGNORE="/usr/share/"
DEPEND="
	~dev-python/compizconfig-python-${PV}
	>=dev-python/pygtk-2.10
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

src_unpack() {
	git_src_unpack
}

src_compile() {
	python setup.py build --prefix=/usr
}

src_install() {
	python setup.py install --root="${D}" --prefix=/usr
}

pkg_postinst() {
	if use gtk ; then gnome2_icon_cache_update ; fi
}
