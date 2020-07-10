# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="A GLib library for Vulkan abstraction."
HOMEPAGE="https://gitlab.freedesktop.org/xrdesktop/gulkan"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://gitlab.freedesktop.org/xrdesktop/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://gitlab.freedesktop.org/xrdesktop/${PN}/-/archive/${PV}/${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~x86"
fi

LICENSE="MIT"
SLOT="0/9999"
IUSE="drm opengl"
REQUIRED_USE=""

DEPEND="
	>=dev-libs/glib-2.50
	media-libs/graphene
	media-libs/vulkan-loader
	x11-libs/cairo
	>=x11-libs/gdk-pixbuf-2.36
	drm? ( x11-libs/libdrm )
	opengl?
	(
		media-libs/glew
		media-libs/glfw
	)
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	virtual/pkgconfig
"
