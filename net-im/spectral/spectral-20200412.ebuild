# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A glossy client for Matrix, written in QtQuick Controls 2 and C++."
HOMEPAGE="https://gitlab.com/b0/spectral"

inherit  cmake-utils 

COMMON_URI="https://github.com/oKcerG/SortFilterProxyModel/archive/36befddf5d57faad990e72c88c5844794f274145.zip"



if [[ ${PV} == 9999 ]]
then
	EGIT_REPO_URI="https://gitlab.com/b0/spectral.git"
	inherit git-r3
else
	SRC_URI="https://gitlab.com/spectral-im/spectral/-/archive/1f95e8888a70000d10317f29c76eb24287bd7390/spectral-1f95e8888a70000d10317f29c76eb24287bd7390.tar.gz -> ${P}.tar.gz
	${COMMON_URI}"

	KEYWORDS="~amd64"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE=""

RDEPEND="
	app-text/cmark
	dev-qt/qtdeclarative
	dev-qt/qtgui
	dev-qt/qtmultimedia[qml]
	dev-qt/qtwidgets
	>=dev-qt/qtquickcontrols2-5.12
	>=dev-libs/libQuotient-0.6_beta1
	dev-libs/libQtOlm
	dev-libs/qtkeychain
	|| ( media-fonts/roboto media-fonts/noto )
	dev-qt/qtsvg
"

DEPEND="
	${RDEPEND}
	>=dev-qt/qtcore-5.12
"
S="${WORKDIR}"/spectral-1f95e8888a70000d10317f29c76eb24287bd7390


src_prepare() {
   move_lib() {
      local IN_DIR="${1}"
      local OUT_DIR
      [ -z "${2}" ] && OUT_DIR="${IN_DIR}" || OUT_DIR="${2%/}/${IN_DIR}"
      mv "${WORKDIR}/${IN_DIR}"*/* "${S}/${OUT_DIR}" || die
   }

   
   local thirdparty_libs=" SortFilterProxyModel" 
   for thirdparty_lib in ${thirdparty_libs} ; do
      move_lib "${thirdparty_lib}" include
   done

   
   cmake-utils_src_prepare
}



pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}