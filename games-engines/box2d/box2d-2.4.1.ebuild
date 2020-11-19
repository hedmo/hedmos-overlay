# Copyright 2019-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="7"
inherit cmake

DESCRIPTION="Box2D is an open source C++ engine for simulating rigid bodies in 2D."
HOMEPAGE="http://www.box2d.org"

SRC_URI="https://github.com/erincatto/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"


LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND=""
DEPEND="${RDEPEND}
	app-arch/unzip
doc? ( >=app-doc/doxygen-1.8.4 )
"

src_configure() {
	local mycmakeargs=(
				 "-DBUILD_SHARED_LIBS=ON"
				 "-DBOX2D_BUILD_DOCS=$(usex doc ON OFF)"
)

	cmake_src_configure
}
 
