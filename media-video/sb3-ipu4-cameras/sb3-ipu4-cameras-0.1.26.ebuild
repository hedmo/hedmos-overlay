# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd udev

DESCRIPTION="Surface Book 3 IPU4P firmware, tuning, modprobe, udev, and WirePlumber rules for libcamera"
HOMEPAGE="https://kernel.org"
S="${WORKDIR}"

LICENSE="GPL-2+ all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 amd64"
IUSE="howdy"
RESTRICT="mirror bindist"

RDEPEND="
	media-libs/libcamera[udev,v4l]
	media-video/pipewire[libcamera]
	media-video/wireplumber
	virtual/udev
	howdy? (
		media-libs/libcamera[gstreamer]
		media-libs/gstreamer:1.0
		media-plugins/gst-plugins-v4l2
		media-video/v4l2loopback
		sys-auth/howdy
	)
"

src_install() {
	insinto /lib/firmware/intel/ipu
	doins "${FILESDIR}/ipu4p_fw.bin"

	insinto /etc/modprobe.d
	doins "${FILESDIR}/11-surface-front-dphy-7.3.conf"

	insinto /usr/share/libcamera/ipa/simple
	doins "${FILESDIR}/ov5693.yaml"
	doins "${FILESDIR}/ov8865.yaml"

	insinto /etc/wireplumber/wireplumber.conf.d
	doins "${FILESDIR}/52-surface-hide-ipu.conf"

	udev_dorules "${FILESDIR}/75-surface-ipu4-libcamera.rules"

	if use howdy; then
		insinto /etc/modprobe.d
		doins "${FILESDIR}/surface-howdy-loopback.conf"

		insinto /etc/modules-load.d
		newins - surface-howdy-loopback.conf <<< "v4l2loopback"

		exeinto /usr/libexec
		doexe "${FILESDIR}/surface-ir-howdy-feed"
		doexe "${FILESDIR}/surface-ir-howdy-trigger"

		systemd_dounit "${FILESDIR}/surface-ir-howdy.service"

		insinto /usr/share/polkit-1/rules.d
		doins "${FILESDIR}/50-surface-ir-howdy.rules"
	fi
}

pkg_postinst() {
	udev_reload
	if use howdy; then
		elog "Enable the Surface IR Howdy service and enroll your face:"
		elog "  sudo modprobe v4l2loopback"
		elog "  sudo systemctl enable --now surface-ir-howdy.service"
		elog "  sudo howdy add"
	fi
}

pkg_postrm() {
	udev_reload
}
