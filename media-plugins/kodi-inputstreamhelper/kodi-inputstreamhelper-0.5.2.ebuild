# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multilib

DESCRIPTION="Kodi module for plugins using InputStream for DRM playback"
HOMEPAGE="https://github.com/emilsvennesson/script.module.inputstreamhelper"

MY_PN="script.module.inputstreamhelper"
MY_P="${MY_PN}-${PV}"

case ${PV} in
9999)
	KEYWORDS=""
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/emilsvennesson/${MY_PN}.git"
	inherit git-r3
	;;
*)
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/emilsvennesson/${MY_PN}/releases/download/v${PV}/${MY_PN}-${PV}+matrix.1.zip -> ${MY_P}.zip"
	S="${WORKDIR}/${MY_PN}"
	;;
esac

LICENSE="LGPL-2.1"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="media-tv/kodi"

src_compile() {
	# no-op
	true
}

src_install() {
	insinto /usr/$(get_libdir)/kodi/addons/"${MY_PN}"
	doins -r *
}
