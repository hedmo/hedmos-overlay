# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson udev xdg

DESCRIPTION="IIO sensors to D-Bus proxy"
HOMEPAGE="https://freedesktop.org"
SRC_URI="https://freedesktop.org-/archive/${PV}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="systemd"

RDEPEND="
	dev-libs/glib:*
	>=dev-libs/libgudev-237
	gnome-base/gnome-common
	>=sys-auth/polkit-0.91
	virtual/udev
	systemd? (
		!sys-apps/openrc
		sys-apps/systemd
	)
"

DEPEND="
	${RDEPEND}
	dev-build/gtk-doc-am
	virtual/pkgconfig
"

src_prepare() {
	if ! use systemd; then
		eapply "${FILESDIR}/no-systemd.patch"
	fi
	eapply_user
}

src_install() {
	meson_src_install
	if ! use systemd; then
		doinitd "${FILESDIR}/iio-sensor-proxy"
	fi
}

pkg_postinst() {
	xdg_pkg_postinst
	udev_reload
}

pkg_postrm() {
	xdg_pkg_postrm
	udev_reload
}
