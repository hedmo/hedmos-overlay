# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
inherit python-single-r1 systemd

DESCRIPTION="KDE Plasma 6 system tray notifier and interactive updater for Gentoo"
HOMEPAGE="https://gentoo.org"
S="${WORKDIR}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 amd64"
IUSE="+live systemd +yakuake"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/pyqt6[gui,widgets]
	')
	app-admin/sudo
	kde-apps/kdialog
	live? ( app-portage/smart-live-rebuild )
	!systemd? ( virtual/cron )
	yakuake? ( kde-apps/yakuake )
	!yakuake? ( kde-apps/konsole )
"

src_install() {
	dosbin "${FILESDIR}/gentoo-tray-worker"
	dobin "${FILESDIR}/gentoo-ask-update"
	python_doscript "${FILESDIR}/gentoo-tray"

	insinto /etc/xdg/autostart
	doins "${FILESDIR}/gentoo-tray.desktop"

	insinto /etc/sudoers.d
	newins - gentoo-tray <<-SUDOEOF
		Defaults:%wheel !requiretty
		%wheel ALL=(root) NOPASSWD: /usr/sbin/gentoo-tray-worker
	SUDOEOF
	fperms 0440 /etc/sudoers.d/gentoo-tray

	if use systemd; then
		systemd_douserunit "${FILESDIR}/gentoo-ask-update.service"
		systemd_douserunit "${FILESDIR}/gentoo-ask-update.timer"
	else
		dosbin "${FILESDIR}/gentoo-cron-ask"
		insinto /etc/cron.d
		newins "${FILESDIR}/gentoo-plasma-tray.cron" gentoo-plasma-tray
	fi
}

pkg_postinst() {
	if use systemd; then
		elog "Enable the weekly Saturday 05:00 user prompt timer on each desktop user with:"
		elog "  systemctl --user enable --now gentoo-ask-update.timer"
	else
		elog "OpenRC cron schedule installed at /etc/cron.d/gentoo-plasma-tray (Saturdays at 05:00)."
		elog "Ensure your cron daemon (e.g. cronie) is enabled in the default runlevel:"
		elog "  rc-update add cronie default"
	fi
}
