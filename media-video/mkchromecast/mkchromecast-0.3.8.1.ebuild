# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{4,5,6,7} )

SRC_URI=https://github.com/muammar/mkchromecast/archive/${PV}.tar.gz
if [[ ${PV} == *9999 ]]; then
	SCM="git-r3"
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/muammar/${PN}.git"
fi

inherit distutils-r1 ${SCM}

DESCRIPTION="Cast Audio/Video to your Google Cast and Sonos Devices"
HOMEPAGE="http://mkchromecast.com"

LICENSE="MIT"
SLOT="0"
RESTRICT="mirror"

KEYWORDS="~amd64 ~x86"
IUSE="alsa ffmpeg gstreamer nodejs +pulseaudio qt5 youtube-dl"

RDEPEND="	gstreamer? ( media-libs/gstreamer )
			pulseaudio? ( media-sound/pulseaudio )
			alsa? ( media-sound/alsa-utils )
			youtube-dl? ( net-misc/youtube-dl[${PYTHON_USEDEP}] )
			nodejs? ( net-libs/nodejs )"

DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/pychromecast[${PYTHON_USEDEP}]
	media-libs/mutagen[${PYTHON_USEDEP}]
	dev-python/flask[${PYTHON_USEDEP}]
	dev-python/netifaces[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
	media-sound/sox
	media-libs/flac
	media-libs/faac
	media-video/ffmpeg
	media-sound/lame
	qt5? ( dev-python/PyQt5[${PYTHON_USEDEP}] )
	"

src_install() {
	exeinto /usr/share/${PN} 
	doexe ${PN}.py
	dosym /usr/share/${PN}/${PN}.py ${EPREFIX}/usr/bin/${PN}
	insinto /usr/share/${PN}/${PN}
	doins mkchromecast/*.py
	insinto /usr/share/${PN}/${PN}/getch
	doins mkchromecast/getch/*
	insinto /usr/share/${PN}/images
	doins images/*.png
	insinto /usr/share/${PN}/nodejs
	doins nodejs/html5-video-streamer.js

	doman man/${PN}.1
	dodoc LICENSE
	insinto /usr/share/pixmaps/${PN}
	doins images/${PN}.xpm
	insinto /usr/share/applications/
	doins ${PN}.desktop
}
