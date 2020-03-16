# Copyright 2019 Gentoo Authors 
# Distributed under the terms of the GNU General Public License v2 

EAPI=7 

PYTHON_COMPAT=( python3_{5,6,7} ) 

inherit git-r3 python-r1 systemd 

DESCRIPTION="Control the lights of Alienware computers under GNU-Linux systems" 
HOMEPAGE="https://github.com/rsm-gh/akbl" 
EGIT_REPO_URI="https://github.com/rsm-gh/akbl.git" 
EGIT_COMMIT="8f4403c97538281725adedbee5960806c35338fb" 

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

