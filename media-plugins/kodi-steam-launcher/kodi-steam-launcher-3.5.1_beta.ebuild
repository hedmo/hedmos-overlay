# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib

DESCRIPTION="steam launcher plugin for Kodi"
HOMEPAGE="https://github.com/teeedubb/teeedubb-xbmc-repo.git"

MY_PN="script.steam.launcher"
MY_P="${MY_PN}-${PV}"

case ${PV} in
9999)
	KEYWORDS=""
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/teeedubb/teeedubb-xbmc-repo.git"
	inherit git-r3
	;;
*)
	KEYWORDS="-* ~amd64"
	SRC_URI="https://github.com/teeedubb/teeedubb-xbmc-repo/raw/master/script.steam.launcher/script.steam.launcher-3.5.1.zip -> ${MY_P}.zip"
	S="${WORKDIR}/${MY_PN}"
	;;
esac

LICENSE="MIT"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="
	=media-tv/kodi-19*
	=media-plugins/kodi-inputstream-adaptive-19*
	media-plugins/kodi-addon-signals
	media-plugins/kodi-inputstreamhelper
	>=dev-python/pycparser-2.18
	dev-python/pycryptodome
"
PATCHES=(
#	"${FILESDIR}/startup_error.patch"

)

src_compile() {
	# no-op
	true
}

src_install() {
	insinto /usr/$(get_libdir)/kodi/addons/script.steam.launcher
	doins -r *
}
