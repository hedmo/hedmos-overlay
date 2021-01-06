# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="A Qt5 library to write cross-platform clients for Matrix"
HOMEPAGE="https://matrix.org/docs/projects/sdk/quotient"

if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/quotient-im/${PN}.git"
else
	COMMIT="0966f4821b6e5460b62d9fe8be14066ed001c1c2"
	SRC_URI="https://github.com/quotient-im/libQuotient/archive/${COMMIT}.tar.gz -> "${P}".tar.gz"
	KEYWORDS="~amd64"
	S="${WORKDIR}"/${PN}-${COMMIT}
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="e2e extra"

RDEPEND="
	dev-qt/qtcore
	dev-qt/qtgui
	dev-qt/qtmultimedia
	dev-qt/qtnetwork
	dev-qt/qttest
	e2e? ( dev-libs/libQtOlm )
	!!dev-libs/libqmatrixclient
"
DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
		-DQuotient_ENABLE_E2EE=$(usex e2e)
		-DUSE_INTREE_LIBQOLM=OFF
		-DQuotient_INSTALL_TESTS=$(usex extra)
	)
	cmake_src_configure
}
