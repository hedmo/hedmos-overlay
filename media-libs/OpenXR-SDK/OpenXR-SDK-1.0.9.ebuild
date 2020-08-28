# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="This project aims to provide a Free and Open Source API and drivers for immersive technology, such as head mounted displays with built in head tracking."
HOMEPAGE="https://github.com/KhronosGroup/OpenXR-SDK"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/KhronosGroup/OpenXR-SDK.gitt"
	inherit git-r3
else
	SRC_URI="https://github.com/KhronosGroup/${PN}/archive/release-${PV}.tar.gz"
	KEYWORDS="~amd64"
fi
S="${WORKDIR}"/${PN}-release-${PV}

LICENSE="Boost-1.0"
SLOT="0"
IUSE=" egl opengl X static-libs"
REQUIRED_USE=""

DEPEND="
	media-libs/vulkan-loader
	x11-libs/libxcb
	x11-libs/xcb-util-keysyms
	x11-libs/libXrandr
	x11-libs/libXxf86vm
	media-libs/mesa
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	virtual/pkgconfig
"


src_configure() {
	local mycmakeargs=(
		"-DDYNAMIC_LOADER=$(usex static-libs OFF ON)"
		
		
	)
		CMAKE_BUILD_TYPE=Release
	cmake_src_configure
}
 
