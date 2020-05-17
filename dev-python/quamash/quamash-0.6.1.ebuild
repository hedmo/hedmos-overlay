# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{6,7} )
inherit distutils-r1

DESCRIPTION="Implementation of the PEP 3156 Event-Loop with Qt."
HOMEPAGE="http://pypi.python.org/pypi/quamash"

MY_P="Quamash"
SRC_URI="https://files.pythonhosted.org/packages/01/1e/cf6f3c38cee61ed04fea58667f673adc67d6412eba0b3327dbb5732c1177/Quamash-0.6.1.tar.gz"
#SRC_URI="mirror://pypi/${MY_P:0:1}/${MY_P}/${MY_P}-${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND="doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	( || ( || ( dev-python/PyQt4 dev-python/PyQt5 ) dev-python/pyside ) )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}-${PV}"

python_compile_all() {
	if use doc; then
		emake -C doc html
	fi
	distutils-r1_python_compile
}

python_install_all() {
	use doc && local HTML_DOCS=doc/build/html/.
	distutils-r1_python_install_all
}
