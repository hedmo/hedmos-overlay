# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..9} )

inherit distutils-r1 xdg

DESCRIPTION="Make your iPad/tablet/computer into a secondary monitor on Linux."
HOMEPAGE="https://github.com/kbumsik/VirtScreen"
SRC_URI="https://github.com/kbumsik/VirtScreen/archive/${PV}.tar.gz"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/VirtScreen-${PV}"

LICENSE="GPL-3"
SLOT="0"

RDEPEND="
dev-python/PyQt5[${PYTHON_USEDEP}]
dev-python/PyQt5-sip[${PYTHON_USEDEP}]
dev-python/netifaces[${PYTHON_USEDEP}]
>=dev-python/quamash-0.6.0
x11-misc/x11vnc
x11-misc/arandr
"

python_install_all() {
    local DOCS=( README.md )
    distutils-r1_python_install_all
}

pkg_preinst() {
    xdg_pkg_preinst
}
pkg_postinst() {
    xdg_pkg_postinst
}

pkg_postrm() {
    xdg_pkg_postrm
}
