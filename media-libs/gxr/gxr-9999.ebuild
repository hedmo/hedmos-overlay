# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="A glib wrapper for the OpenVR and soon the OpenXR API."
HOMEPAGE="https://gitlab.freedesktop.org/xrdesktop/gxr"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://gitlab.freedesktop.org/xrdesktop/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://gitlab.freedesktop.org/xrdesktop/${PN}/-/archive/${PV}/${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~x86"
fi

LICENSE="MIT"
SLOT="0/9999"
IUSE="cairo drm egl opengl X"
REQUIRED_USE=""

DEPEND="
	>=media-libs/gulkan-0.13.0
	media-libs/openvr
	>=x11-libs/gtk+-3.22
	cairo? ( x11-libs/cairo )
	drm? ( x11-libs/libdrm )
	egl? ( media-libs/mesa[egl] )
	opengl?
	(
		media-libs/glew
		media-libs/glfw
	)
	X? ( x11-base/xorg-server )
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}/openvr.patch"
)