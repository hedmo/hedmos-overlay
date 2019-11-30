# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit cmake-utils git

DESCRIPTION="Compiz Configuration System"
HOMEPAGE="http://www.compiz.org/"
EGIT_REPO_URI="https://github.com/hedmo/libcompizconfig/"
EGIT_BRANCH="master"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	dev-libs/libxml2
	dev-libs/libxslt
	dev-libs/protobuf
	~x11-wm/compiz-${PV}
"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.19
"


S="${WORKDIR}/${PN}"

src_configure() {
     
	mycmakeargs=(
		"-DCOMPIZ_DISABLE_SCHEMAS_INSTALL=ON"
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

# Install the config file manually
   dodir /etc/compizconfig
   insinto /etc/compizconfig
   doins config/config 


	# Install the FindCompizConfig.cmake file
	insinto "/usr/share/cmake/Modules"
	doins "cmake/FindCompizConfig.cmake" || die "Failed to install FindCompizConfig.cmake"
}
