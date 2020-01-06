# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6,3_7} )

inherit distutils-r1

DESCRIPTION="Library for Python 2 and 3 to communicate with the Google Chromecast"
HOMEPAGE="https://github.com/balloob/pychromecast"
SRC_URI="https://github.com/balloob/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

IUSE=""

RDEPEND=">=dev-python/six-1.10.0[${PYTHON_USEDEP}]
	>=dev-python/zeroconf-0.17.4[${PYTHON_USEDEP}]
	>=dev-python/requests-2.0[${PYTHON_USEDEP}]
	|| (
		>=dev-libs/protobuf-3.0.0_beta2[python,${PYTHON_USEDEP}]
		dev-python/protobuf-python[${PYTHON_USEDEP}]
	)"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"
