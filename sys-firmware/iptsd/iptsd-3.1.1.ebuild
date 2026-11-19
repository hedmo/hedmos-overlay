# Copyright 2023-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-info meson udev

DESCRIPTION="Userspace daemon for Intel Precise Touch & Stylus technology"
HOMEPAGE="https://github.com"
SRC_URI="https://github.com{PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="systemd"

DEPEND="
	dev-cpp/cli11
	dev-cpp/eigen:3
	dev-cpp/ms-gsl
	dev-libs/hidapi
	dev-libs/inih
	dev-libs/spdlog:=
	media-libs/libsdl2
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-build/meson
	dev-build/ninja
"

src_configure() {
	local emesonargs=(
		-Dservice_manager=$(usex systemd systemd none)
	)
	meson_src_configure
}

src_install() {
	meson_src_install

	if ! use systemd; then
		newbin "${FILESDIR}/sh" iptsd-run
		newinitd "${FILESDIR}/initd" iptsd
	fi
}

pkg_postinst() {
	udev_reload

	if linux_config_exists; then
		if ! linux_chkconfig_present HID_IPTS; then
			ewarn "HID_IPTS is not set in your kernel. It's required for iptsd to work."
		fi
		if ! linux_chkconfig_present HID_ITHC; then
			ewarn "HID_ITHC is not set in your kernel. It's required for newer surface devices."
		fi
	fi
}

pkg_postrm() {
	udev_reload
}
