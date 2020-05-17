# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( python{2_7,3_6} )
inherit distutils-r1 udev 

DESCRIPTION="AlienFX is a Linux utility to control the lighting effects of your Alienware computer."
HOMEPAGE="https://github.com/trackmastersteve/alienfx"


if [[ ${PV} == 9999 ]]
then
	EGIT_REPO_URI="https://github.com/trackmastersteve/alienfx.git"
	inherit git-r3
else
	SRC_URI="https://github.com/trackmastersteve/alienfx/archive/v${PV}.tar.gz"

	KEYWORDS="~amd64"
fi


LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
        virtual/libusb:1
        dev-python/pycairo
        dev-python/pyusb
        dev-python/setuptools[${PYTHON_USEDEP}]
        dev-python/pygobject 
        dev-python/future
        dev-python/pyusb
      >=x11-libs/gtk+-2.18.0"



python_install_all() { 
    udev_dorules alienfx/data/etc/udev/rules.d/10-alienfx.rules 
    distutils-r1_python_install_all 
}
