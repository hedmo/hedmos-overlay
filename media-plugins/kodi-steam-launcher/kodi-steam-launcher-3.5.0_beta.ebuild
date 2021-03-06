# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib

DESCRIPTION="Inputstream based Netflix plugin for Kodi"
HOMEPAGE="https://github.com/asciidisco/plugin.video.netflix"

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
	SRC_URI="https://www.dropbox.com/s/ry7dbmuh72l55nu/script.steam.launcher.zip?dl=0 -> ${MY_P}.zip"
	S="${WORKDIR}/${MY_PN}"
	;;
esac

LICENSE="MIT"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="
	=media-tv/kodi-19*
	=media-plugins/kodi-inputstream-adaptive-2*
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
