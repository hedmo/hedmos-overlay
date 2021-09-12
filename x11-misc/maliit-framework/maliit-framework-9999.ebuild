# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake
DESCRIPTION="A flexible and cross platform input method framework"
HOMEPAGE="https://github.com/maliit/framework"

if [[ ${PV} == 9999 ]]; then
		EGIT_REPO_URI="https://github.com/maliit/framework.git"
inherit git-r3
else
		SRC_URI="https://github.com/maliit/framework/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
		KEYWORDS="~amd64 ~arm"
S="${WORKDIR}"/framework-${PV}
fi

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="+dbus doc +gtk test"

DEPEND="
	dbus? ( sys-apps/dbus )
	gtk? ( x11-libs/gtk+:3 )
	dev-qt/qtdeclarative
	kde-frameworks/kwayland
	dev-libs/wayland-protocols
"

RDEPEND="${DEPEND}"

BDEPEND="
	app-doc/doxygen
	media-gfx/graphviz
"

RESTRICT="test"

DOCS=( README )

src_configure() {
	local mycmakeargs=(
		-Denable-docs=$(usex doc ON OFF)
		-Denable-dbus-activation=$(usex dbus ON OFF)
		-Denable-wayland-gtk=$(usex gtk ON OFF)
		-Denable-tests=$(usex test ON OFF)
	)
	use doc && mycmakeargs+=(
		-DDOC_INSTALL_DIR="share/doc/${P}"
	)

	cmake_src_configure
}
