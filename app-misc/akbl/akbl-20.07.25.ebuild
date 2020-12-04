# Copyright 2019 Gentoo Authors 
# Distributed under the terms of the GNU General Public License v2 

EAPI=7 

PYTHON_COMPAT=( python3_{6,7,8} ) 

inherit python-r1 systemd 



DESCRIPTION="Control the lights of Alienware computers under GNU-Linux systems" 
HOMEPAGE="https://senties-martinelli.com/software/akbl" 

if [[ ${PV} == 9999 ]]
then
	EGIT_REPO_URI="https://github.com/rsm-gh/akbl.git"
	inherit git-r3
else
    COMMIT="269cef8ab5b831e9f419c415ad3978ac99a3bfb0"
	SRC_URI="https://github.com/rsm-gh/akbl/archive/${COMMIT}.zip"

	KEYWORDS="~amd64"
fi

if [[ ${PV} == 9999 ]]
then
S="${WORKDIR}/${P}"
else
S="${WORKDIR}/akbl-${COMMIT}"
fi
LICENSE="GPL-3" 
SLOT="0" 

DEPEND=" 
        dev-libs/libappindicator:3 
        dev-python/pyro:4" 
RDEPEND="${DEPEND}" 
BDEPEND="" 

src_prepare() { 
        default 
        sed -i "s/__AKBL_VERSION__/${PV}/g" "${S}/usr/lib/python3/AKBL/Addons/GUI/GUI.glade" 
        sed -i "s/__version__=None/__version__='${PV}'/g" "${S}/usr/share/AKBL/launch/commands.py" 
        sed -i "s/_DEBUG=True/_DEBUG=False/g" "${S}/usr/lib/python3/AKBL/utils.py" 

        sed -i "s/import os/import os,AKBL/g" "${S}/usr/lib/python3/AKBL/Paths.py" 
        sed -i "s/'\/usr\/lib\/python3\/AKBL'/os.path.dirname\(AKBL\.__file__\)/g" "${S}/usr/lib/python3/AKBL/Paths.py" 
} 

QA_PREBUILT="usr/share/AKBL/libusb-1.0.so.0" 

src_install() { 
        insinto /usr/share/AKBL 
        doins -r usr/share/AKBL/. 

        insinto /usr/share/doc/${P} 
        doins -r usr/share/doc/AKBL/. 

        insinto /usr/share/applications/ 
        doins usr/share/applications/AKBL.desktop 

        dobin usr/bin/akbl 

        installation() { 
                insinto $(python_get_sitedir) 
                doins -r usr/lib/python3/AKBL 
        } 
        python_foreach_impl installation 

        systemd_dounit usr/lib/systemd/system/akbl.service 
}

