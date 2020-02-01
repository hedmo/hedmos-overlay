# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop

MY_JAR="${PN}-launcher-${PV}.jar"

DESCRIPTION="Official Java launcher for Minecraft"
HOMEPAGE="https://minecraft.net"
SRC_URI="http://launcher.mojang.com/mc/launcher/jar/fa896bd4c79d4e9f0d18df43151b549f865a3db6/launcher.jar.lzma -> ${MY_JAR}.lzma
	https://minecraft.net/android-icon-192x192.png -> minecraft.png"

LICENSE="Minecraft-clickwrap-EULA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	media-libs/openal
	virtual/opengl
	>=virtual/jre-1.8"

S="${WORKDIR}"

src_install() {
	dobin "${FILESDIR}"/minecraft
	doicon -s 192 "${DISTDIR}"/minecraft.png
	insinto /usr/share/games/"${PN}"
	newins "${MY_JAR}" launcher.jar

	make_desktop_entry minecraft Minecraft minecraft
}

pkg_postinst() {
	einfo "This package has installed the Java Minecraft launcher."
	einfo "To actually play the game, you need to purchase an account at:"
	einfo "    ${HOMEPAGE}"
}
