# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake git-r3

DESCRIPTION="The open source OpenXR runtime."
HOMEPAGE="https://monado.dev"
EGIT_REPO_URI="https://gitlab.freedesktop.org/monado/monado.git"
LICENSE="Boost-1.0"
SLOT="0"

# TODO: OpenHMD
BDEPEND=""
DEPEND="
	media-libs/OpenXR-SDK
	media-libs/mesa
	dev-cpp/eigen:3
	dev-util/glslang
	virtual/libusb
	virtual/libudev
	media-libs/libv4l
"
RDEPEND="${DEPEND}"

src_configure() {
	local ecmakeargs=(
		-DSYSTEM_CJSON=ON
	)

	cmake_src_configure
} 
