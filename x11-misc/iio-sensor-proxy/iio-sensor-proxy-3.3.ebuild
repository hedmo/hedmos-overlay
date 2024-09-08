# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools meson udev xdg

DESCRIPTION="IIO sensors to D-Bus proxy"
HOMEPAGE="https://gitlab.freedesktop.org/hadess/iio-sensor-proxy"

SRC_URI="https://gitlab.freedesktop.org/hadess/${PN}/-/archive/${PV}/${P}.tar.gz"
KEYWORDS="*"

LICENSE="GPL-3"
SLOT="0"
IUSE="systemd"

RDEPEND="
	dev-libs/glib
	dev-libs/libgudev
	sys-apps/dbus
	systemd? ( >=sys-apps/systemd-233:0 )
	virtual/udev
"
DEPEND="
	${RDEPEND}
	dev-util/gtk-doc
	dev-util/gtk-doc-am
	virtual/pkgconfig
"

src_prepare() {
	use systemd || eapply "${FILESDIR}"/${PN}_nosystemd.patch
	default
}

src_install() {
	meson_src_install
	# OpenRC init file
	if ! use systemd ; then
		newinitd "${FILESDIR}/${PN}.openrc" ${PN}
	fi
}

pkg_postinst() {
	xdg_pkg_postinst
	elog
	elog "enable iio-sensor-proxy service:"
	elog
	elog "[openrc]	# rc-update add iio-sensor-proxy"
	elog "[systemd]	# systemctl enable iio-sensor-proxy"
	elog
	elog "Reboot computer."
}

pkg_postrm() {
	xdg_pkg_postrm
}
