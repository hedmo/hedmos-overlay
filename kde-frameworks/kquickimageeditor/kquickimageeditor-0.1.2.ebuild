# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_TEST="false"
KFMIN=5.70.0
QTMIN=5.15.2
inherit ecm kde.org

DESCRIPTION="KQuickImageEditor is providing basic image editing capabilities."

SRC_URI="https://github.com/KDE/${PN}/archive/v${PV}.tar.gz"
LICENSE="LGPL-2+"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	>=dev-qt/qtcore-${QTMIN}:5
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtquickcontrols-${QTMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
"
RDEPEND="${DEPEND}
	>=kde-frameworks/kirigami-${KFMIN}:5
"
