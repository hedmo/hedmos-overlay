# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit ecm

DESCRIPTION="xrdesktop applet for KDE Plasma."
HOMEPAGE="https://gitlab.freedesktop.org/xrdesktop/kdeplasma-applets-xrdesktop"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://gitlab.freedesktop.org/xrdesktop/kdeplasma-applets-xrdesktop.git"
	inherit git-r3
else
	SRC_URI="https://gitlab.freedesktop.org/xrdesktop/${PN}/-/archive/${PV}/kdeplasma-applets-xrdesktop.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~x86"
fi

LICENSE="MIT"
SLOT="0/9999"
IUSE=""
REQUIRED_USE=""

DEPEND="
	kde-plasma/kwin-effect-xrdesktop
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	virtual/pkgconfig
"
