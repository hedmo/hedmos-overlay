# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib

DESCRIPTION="Inputstream based Netflix plugin for Kodi"
HOMEPAGE="https://github.com/CastagnaIT/plugin.video.netflix"

MY_PN="plugin.video.netflix"
MY_P="${MY_PN}-${PV}"

case ${PV} in
9999)
	KEYWORDS=""
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/CastagnaIT/plugin.video.netflix.git"
	inherit git-r3
	;;
*)
	CODENAME="matrix.1"
	KEYWORDS="~amd64"
	SRC_URI="https://github.com/CastagnaIT/${MY_PN}/releases/download/v${PV}/${MY_PN}-${PV}+${CODENAME}.zip -> ${MY_P}.zip"
	S="${WORKDIR}/${MY_PN}"
	;;
esac

LICENSE="MIT"
SLOT="0"
IUSE=""

DEPEND="
	=media-tv/kodi-19*
	=media-plugins/kodi-inputstream-adaptive-2*
	media-plugins/kodi-addon-signals
	media-plugins/kodi-inputstreamhelper
	dev-python/codecov
	dev-python/mysql-connector-python
	dev-python/requests
	dev-python/polib
	dev-python/pylint
	>=dev-python/pycparser-2.18
	dev-python/pycryptodome
	dev-python/setuptools
	dev-python/xmlschema
	net-libs/tox
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
