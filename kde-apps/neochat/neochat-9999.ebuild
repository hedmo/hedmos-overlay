# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_TEST="false"
KFMIN=5.70.0
QTMIN=5.15.2
DESCRIPTION="Neochat is a client for Matrix and using KDE frameworks"
HOMEPAGE="https://github.com/KDE/neochat.git"

inherit ecm kde.org

if [[ ${PV} == 9999 ]]
then
	EGIT_REPO_URI="https://github.com/KDE/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/KDE/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

	KEYWORDS="~amd64"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND="
	app-text/cmark
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtquickcontrols2-${QTMIN}:5
	>=dev-qt/qtmultimedia-${QTMIN}:5[qml]
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtquickcontrols2-${QTMIN}:5
	>=dev-qt/qtsvg-${QTMIN}:5
	>=dev-libs/qtkeychain-0.11.1
	>=dev-libs/libQuotient-0.6.0
	>=kde-frameworks/kquickimageeditor-0.1.2
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kdbusaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/knotifications-${KFMIN}:5
	|| ( media-fonts/roboto media-fonts/noto )
	sys-devel/gettext
"

RDEPEND="${DEPEND}
	>=dev-qt/qtcore-${QTMIN}:5
	>=kde-frameworks/kirigami-${KFMIN}:5
"

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
