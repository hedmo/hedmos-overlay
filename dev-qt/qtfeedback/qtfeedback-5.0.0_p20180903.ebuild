# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils

MY_VER="$(ver_cut 1-3)"

DESCRIPTION="Qt Tactile Feedback Add-on Module"
HOMEPAGE="https://github.com/qtproject/qtfeedback"
if [[ ${PV} == 9999 ]]; then
		EGIT_REPO_URI="https://github.com/qt/qtfeedback.git"
inherit git-r3
else
COMMIT="a14bd0bb1373cde86e09e3619fb9dc70f34c71f2"
		SRC_URI="https://github.com/qt/qtfeedback/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
		KEYWORDS="~amd64 ~arm"
S="${WORKDIR}"/${PN}-${COMMIT}
fi

LICENSE="|| ( GPL-2 GPL-3 LGPL-3 ) FDL-1.3"
SLOT="0"

DEPEND="
		dev-qt/qtcore:5
		dev-qt/qtxmlpatterns:5
		dev-qt/qtdeclarative:5
		dev-qt/qtmultimedia:5
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/Fail_to_find_plugin.patch" )

src_prepare() {
		default
		sed -i "s/\(MODULE_VERSION = \)[0-9.]*/\1 ${MY_VER}/" .qmake.conf || die
		/usr/lib64/qt5/bin/syncqt.pl -version ${MY_VER} -module QtFeedback || die
}

src_configure() {
		eqmake5
}

src_install() {
		emake INSTALL_ROOT="${D}" install
}
