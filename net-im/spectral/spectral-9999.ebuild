 
# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A glossy client for Matrix, written in QtQuick Controls 2 and C++."
HOMEPAGE="https://gitlab.com/b0/spectral"

inherit eutils cmake-utils git-r3
EGIT_REPO_URI="https://gitlab.com/b0/spectral.git"
EGIT_SUBMODULES=("include/SortFilterProxyModel")
if [[ ${PV} != "9999" ]]; then
	EGIT_COMMIT="${PV}"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE=""

RDEPEND="dev-qt/qtgui
	dev-qt/qtmultimedia[qml]
	dev-qt/qtwidgets
	>=dev-qt/qtquickcontrols2-5.12
	>dev-libs/libQuotient-0.5.1.2
	dev-libs/libQtOlm
	media-fonts/noto-emoji
	dev-qt/qtsvg"
DEPEND="${RDEPEND}
	>=dev-qt/qtcore-5.12"

src_configure() {
	cmake-utils_src_configure
}
