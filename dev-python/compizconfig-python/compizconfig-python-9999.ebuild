# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils git

EGIT_REPO_URI="https://github.com/hedmo/compizconfig-python"

DESCRIPTION="Compizconfig Python Bindings"
HOMEPAGE="http://www.compiz.org/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	>=dev-libs/glib-2.6
	|| (
		dev-python/cython
		dev-python/pyrex
	)
	~x11-libs/libcompizconfig-${PV}
	~x11-wm/compiz-${PV}
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

src_unpack() {
	git_src_unpack
}

src_install() {
	distutils_src_install
}
