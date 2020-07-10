# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="Synthesize keyboard and mouse input on X11 and Wayland with various backends."
HOMEPAGE="https://gitlab.freedesktop.org/xrdesktop/libinputsynth"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://gitlab.freedesktop.org/xrdesktop/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://gitlab.freedesktop.org/xrdesktop/${PN}/-/archive/${PV}/${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~x86"
fi

LICENSE="MIT"
SLOT="0/9999"
IUSE="X"
REQUIRED_USE=""

DEPEND="
	>=dev-libs/glib-2.50
	x11-misc/xdotool
	X? (
		x11-base/xorg-server
		x11-libs/libXi
	)
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	virtual/pkgconfig
"
