# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="A flexible and cross-platform input method framework"
HOMEPAGE="https://maliit.github.io/"
SRC_URI="https://github.com/${PN/-/\/}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm"

IUSE="dbus doc examples glib +hwkeyboard wayland xcb"

BDEPEND="virtual/pkgconfig"

DEPEND="
	dev-qt/qtcore:5=
	dev-qt/qtdbus:5=
	dev-qt/qtdeclarative:5=
	dev-qt/qtgui:5=
	doc? ( app-doc/doxygen )
	glib? ( dev-libs/glib )
	hwkeyboard? ( virtual/udev )
	wayland? (
		dev-qt/qtgui:5=[libinput]
		dev-libs/wayland-protocols
		dev-qt/qtwaylandscanner:5
	)
	xcb? ( x11-libs/libxcb )"

RDEPEND="${DEPEND}"

S="${WORKDIR}"/${P#maliit-}

src_prepare() {
	cmake_src_prepare

	sed -e "s|doc/maliit-framework)|doc/${PF})|" \
		-e "s|maliit-framework-doc)|${PF}/html)|" \
		-i CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-Denable-dbus-activation=ON
		-Denable-glib=ON
		-Denable-tests=OFF

		-Denable-docs=$(usex doc)
		-Denable-examples=$(usex examples)
		-Denable-glib=$(usex glib)
		-Denable-hwkeyboard=$(usex hwkeyboard)
		-Denable-wayland=$(usex wayland)
		-Denable-xcb=$(usex xcb)
	)
	cmake_src_configure
}
