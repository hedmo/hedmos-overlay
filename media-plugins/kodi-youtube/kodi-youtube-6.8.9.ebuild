# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib

DESCRIPTION="Inputstream based youtube plugin for Kodi"
HOMEPAGE="https://github.com/anxdpanic/plugin.video.youtube"

MY_PN="plugin.video.youtube"
MY_P="${MY_PN}-${PV}"

case ${PV} in
9999)
	KEYWORDS=""
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/anxdpanic/plugin.video.youtube.git"
	inherit git-r3
	;;
*)
	CODENAME="matrix.1"
	KEYWORDS="~amd64"
	SRC_URI="https://github.com/anxdpanic/${MY_PN}/releases/download/${PV}/${MY_PN}-${PV}+${CODENAME}.zip -> ${MY_P}.zip"
	S="${WORKDIR}/${MY_PN}"
	;;
esac

LICENSE="MIT"
SLOT="0"
IUSE=""

DEPEND="
	=media-tv/kodi-19*
	media-plugins/kodi-addon-signals
	media-plugins/kodi-inputstreamhelper
	dev-python/requests
	dev-python/six
"
RDEPEND="
	${DEPEND}
	"

src_compile() {
	# no-op
	true
}

src_install() {
	insinto /usr/$(get_libdir)/kodi/addons/plugin.video.netflix
	doins -r *
}
