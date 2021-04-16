# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
inherit distutils-r1

DESCRIPTION="Test utility for hardware components in postmarketOS phones"
HOMEPAGE="https://gitlab.com/MartijnBraam/hwtest"
COMMIT="256ad7dc4fd5cb3bc18d7db4da66aaf5b52ec461"
SRC_URI="https://gitlab.com/MartijnBraam/hwtest/-/archive/"${COMMIT}"/hwtest-"${COMMIT}".tar.gz -> "${P}".tar.gz"
S=""${WORKDIR}"/"${PN}"-"${COMMIT}""

LICENSE="MIT"
SLOT="0"
KEYWORDS="~arm"

RDEPEND="
	app-misc/evtest
	games-util/joystick
	media-sound/alsa-utils[bat]
	media-tv/v4l-utils
	media-video/ffmpeg
"
