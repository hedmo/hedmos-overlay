# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A glossy Matrix collaboration client for the web"
HOMEPAGE="https://riot.im"

inherit unpacker xdg-utils

if [[ ${PV} == "9999" ]]; then
	inherit git-r3

	SRC_URI=""
	EGIT_REPO_URI="https://github.com/vector-im/riot-web.git"
	EGIT_BRANCH="develop"
else
	SRC_URI="https://github.com/vector-im/riot-web/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="Apache-2.0"
SLOT="0"
IUSE="+emoji"
REQUIRED_USE=""

DEPEND="sys-devel/binutils:*
	>=net-libs/nodejs-12.14.0
	sys-apps/yarn
	x11-libs/libXScrnSaver
	net-print/cups
	dev-libs/nss
	gnome-base/gconf
	emoji? ( >=media-fonts/noto-emoji-20180823 )"
RDEPEND="${DEPEND}"

QA_PREBUILT="
	opt/Riot/chrome-sandbox
	opt/Riot/libGLESv2.so
	opt/Riot/libEGL.so
	opt/Riot/libffmpeg.so
	opt/Riot/libnode.so
	opt/Riot/riot-web
	opt/Riot/swiftshader/libGLESv2.so
	opt/Riot/swiftshader/libEGL.so
	opt/Riot/swiftshader/libvk_swiftshader.so"

src_prepare() {
	default

	if [[ ${PV} == "9999" ]]; then
		"${S}"/scripts/fetch-develop.deps.sh
	fi

	yarn install || die "Yarn module installation failed"

	cp "${S}"/config.sample.json "${S}"/config.json || die
}

src_compile() {
	yarn run build || die "Build failed"

	"${S}"/node_modules/.bin/electron-builder --linux --x64 || die "Bundling failed"
}

src_install() {
	unpack electron_app/dist/riot-web*.deb
	tar xvf data.tar.xz || die

	mv usr/share/doc/${PN} usr/share/doc/${PF} || die
	gunzip usr/share/doc/${PF}/changelog.gz || die

	insinto /
	doins -r usr
	doins -r opt
	fperms +x /opt/Riot/${PN}
	dosym ../../opt/Riot/${PN} /usr/bin/${PN}
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}
pkg_postinst() {
	einfo "riot-web requires internet access"
	einfo "To allow network access you need to disable network-sandbox:"
	einfo "take a look at https://wiki.gentoo.org/wiki//etc/portage/package.env"
}
