# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Official Minecraft Launcher"
HOMEPAGE="https://www.minecraft.net"
SRC_URI="https://launcher.mojang.com/download/Minecraft.tar.gz -> ${P}.tar.gz"

inherit desktop

LICENSE="Minecraft"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
RESTRICT="mirror"

S="${WORKDIR}/${PN}"

DEPEND=""
RDEPEND="${DEPEND}
	app-arch/bzip2
	dev-libs/atk
	dev-libs/expat
	dev-libs/fribidi
	dev-libs/glib
	dev-libs/gmp
	dev-libs/libbsd
	dev-libs/libffi
	dev-libs/libpcre
	dev-libs/libtasn1
	dev-libs/libunistring
	dev-libs/nettle
	dev-libs/nspr
	dev-libs/nss
	gnome-base/gconf
	media-gfx/graphite2
	media-libs/alsa-lib
	media-libs/fontconfig
	media-libs/freetype
	media-libs/harfbuzz
	media-libs/libpng:0
	net-dns/libidn2
	net-libs/gnutls
	net-print/cups
	sys-apps/dbus
	sys-apps/util-linux
	sys-libs/zlib
	>=virtual/jre-1.8
	virtual/opengl
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:2
	x11-libs/libX11
	x11-libs/libXScrnSaver
	x11-libs/libXau
	x11-libs/libXcomposite
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXdmcp
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXtst
	x11-libs/libxcb
	x11-libs/pango
	x11-libs/pixman"
BDEPEND=""

src_install() {
	insinto /opt/"${P}"
	doins -r locales
	doins *.pak *.so *.bin *.dat chrome-sandbox

	exeinto /opt/"${P}"
	doexe minecraft-launcher

	cat <<-EOF > "minecraft-launcher"
	#!/bin/sh
	cd "/opt/${P}"
	./minecraft-launcher
	EOF

	into /opt
	dobin minecraft-launcher

	doicon "${FILESDIR}/${PN}.png"
	make_desktop_entry "${PN}" "Minecraft"
}
 
