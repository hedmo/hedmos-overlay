# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake 

DESCRIPTION="The open source OpenXR runtime."
HOMEPAGE="https://monado.dev"
LICENSE="Boost-1.0"
SLOT="0"
if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://gitlab.freedesktop.org/monado/monado.git"
	inherit git-r3
else
	SRC_URI="https://gitlab.freedesktop.org/${PN}/${PN}/-/archive/v${PV}.tar.gz"
	KEYWORDS="~amd64"
fi

S="${WORKDIR}"/monado-v0.3.0-d1f30e4a5a8f872fd634dbab9317dc6e9597d7d2


BDEPEND=""
DEPEND="
	media-libs/OpenHMD
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
