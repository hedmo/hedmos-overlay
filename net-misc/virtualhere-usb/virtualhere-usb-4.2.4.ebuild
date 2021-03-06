# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CLIENT_URI="https://github.com/hedmo/stuff/raw/main/virtualhere/virtualhere-4.2.4/"
SERVER_URI="https://github.com/hedmo/stuff/raw/main/virtualhere/virtualhere-4.2.4/"

inherit linux-info

DESCRIPTION="Share USB devices over the network"
HOMEPAGE="https://virtualhere.com"
SRC_URI="client? (
		amd64? ( ${CLIENT_URI}vhclientx86_64 ) -> vhclientx86_64-${PV}
	)
	gui? (
		amd64? ( ${CLIENT_URI}vhuit64 ) -> vhuit64-${PV}
	)
	server? (
		amd64? ( ${SERVER_URI}vhusbdx86_64 ) -> vhusbdx86_64-${PV}
	)"
LICENSE="openssl no-source-code"
SLOT="0"
KEYWORDS="~amd64 "
IUSE="client gui +server"
REQUIRED_USE="|| ( client gui server )"
RESTRICT="mirror"

RDEPEND="acct-user/vhusb"
DEPEND="virtual/linux-sources"

S="${WORKDIR}"

QA_PREBUILT="/opt/vhusb/vhclient*
	/opt/vhusb/vhuit*
	/opt/vhusb/vhusbd*"

pkg_setup() {
	use client && CONFIG_CHECK="~USBIP_VHCI_HCD"
	use gui    && CONFIG_CHECK="~USBIP_VHCI_HCD"
	use server && CONFIG_CHECK="~USBIP_HOST"

	linux-info_pkg_setup
}

src_unpack() {
	for AFILE in ${A}; do
		cp "${DISTDIR}"/"${AFILE}" "${S}" || die "copy failed for ${AFILE}"
	done
}
src_prepare() {
default
	if use client ; then
		mv -v "${WORKDIR}/vhclientx86_64-${PV}" "${WORKDIR}/vhclientx86_64" || die
	fi

		mv -v "${WORKDIR}/vhuit64-${PV}" "${WORKDIR}/vhuit64" || die
		mv -v "${WORKDIR}/vhusbdx86_64-${PV}" "${WORKDIR}/vhusbdx86_64" || die

}
src_install() {
	exeinto /opt/vhusb
	insinto /opt/vhusb

	use gui && doexe vhuit*

	if use client ; then
		doexe vhclient*
		newconfd "${FILESDIR}"/vhusb-client.confd vhusb-client
		use amd64 && newinitd "${FILESDIR}"/vhusb-client.amd64 vhusb-client
	fi

	if use server ; then
		doexe vhusbd*
		doins "${FILESDIR}"/config.ini
		newconfd "${FILESDIR}"/vhusb-server.confd vhusb-server
		use amd64 && newinitd "${FILESDIR}"/vhusb-server.amd64 vhusb-server

	fi
}
