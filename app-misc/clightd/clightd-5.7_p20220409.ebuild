# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN^}"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/FedeDP/${MY_PN}"
	EGIT_BRANCH="master"
	VCS_ECLASS="git-r3"
else
	COMMIT="95c71889c59a7371948e6feabc0aaf19a4f49fcf"
	SRC_URI="https://github.com/FedeDP/${MY_PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${P^}"
	KEYWORDS="~amd64 ~x86"
fi

inherit cmake ${VCS_ECLASS}

DESCRIPTION="A linux bus interface for screen settings (brightness, gamma, etc.)"
HOMEPAGE="https://github.com/FedeDP/Clightd"

LICENSE="GPL-3"
SLOT="0"
IUSE="ddc dpms gamma pipewire screen yoctolight"

DEPEND="
	>=dev-libs/libmodule-5.0.0
	media-libs/libjpeg-turbo
	sys-apps/dbus
	sys-auth/polkit
	virtual/libudev
	|| ( sys-auth/elogind sys-apps/systemd )
	ddc? (
		>=app-misc/ddcutil-0.9.5
	)
	dpms? (
		dev-libs/wayland
		x11-libs/libdrm
		x11-libs/libXext
		x11-libs/libX11
	)
	gamma? (
		dev-libs/wayland
		x11-libs/libdrm
		x11-libs/libXrandr
		x11-libs/libX11
	)
	pipewire? (
		media-video/pipewire
	)
	screen? (
		x11-libs/libX11
	)
	yoctolight? (
		virtual/libusb:1
	)
"

RDEPEND="${DEPEND}"
BDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DENABLE_DDC=$(usex ddc)
		-DENABLE_DPMS=$(usex dpms)
		-DENABLE_GAMMA=$(usex gamma)
		-DENABLE_SCREEN=$(usex screen)
		-DENABLE_YOCTOLIGHT=$(usex yoctolight)
		-DMODULE_LOAD_DIR=/etc/modules-load.d
	)

	cmake_src_configure
}
