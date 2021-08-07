# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="IIO accelerometer sensor to input device proxy"
HOMEPAGE="https://gitlab.freedesktop.org/hadess/iio-sensor-proxy"
SRC_URI="https://gitlab.freedesktop.org/hadess/${PN}/-/archive/${PV}/${P}.tar.gz"

LICENSE="Unlicense"
# Unknown. There is no info about the license ATM.
SLOT="0"
KEYWORDS="~amd64 ~arm"
IUSE="systemd test"

RDEPEND="
	gnome-base/gnome-common
	app-misc/geoclue:*
"
DEPEND="
	${RDEPEND}
"

DOCS=( README.md )

src_configure() {
	local emesonargs=(
		"$(meson_use systemd systemdsystemunitdir)"
		"$(meson_use test gtk-tests)"
	)
	meson_src_configure
}

src_install() {
	meson_src_install
	if use !systemd; then
		newinitd "${FILESDIR}"/iio-sensor-proxy.initd iio-sensor-proxy
	fi
}
