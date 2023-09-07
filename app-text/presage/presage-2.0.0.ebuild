# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit eutils autotools flag-o-matic
DESCRIPTION="The intelligent predictive text entry system"
HOMEPAGE="http://presage.sourceforge.io"

LICENSE="GPL-2+"
SLOT="0"



if [[ ${PV} == 9999 ]]; then
inherit git-r3
	EGIT_REPO_URI="https://github.com/sailfish-keyboard/presage.git"
	EGIT_COMMIT="tags/${PV}"
else
COMMIT="a060594faaf23c31c6686c6b838a71dbfa7e7892"
SRC_URI="https://github.com/sailfish-keyboard/presage/archive/refs/tags/${PV}.tar.gz"
#S="${WORKDIR}"/${PN}-${COMMIT}
KEYWORDS="~amd64 "
fi

IUSE="examples doc gtk python +sqlite test"

RDEPEND="
	examples? ( sys-libs/ncurses )
	gtk? ( x11-libs/gtk+ )
	python? ( dev-lang/python dev-python/dbus-python )
	sqlite? ( dev-db/sqlite )
	dev-libs/marisa
	app-text/dos2unix

"

DEPEND="${COMMON_DEPEND}
	doc? ( app-doc/doxygen )
	dev-lang/swig
	test? ( dev-util/cppunit )
	sys-apps/help2man
"

PATCHES="${FILESDIR}/${PN}-0.9.1-automagic.patch
	${FILESDIR}/${PN}-gcc6.patch"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# code is not C++17 ready
	append-cxxflags -std=c++14
	econf \
		$(use_enable doc documentation) \
		$(use_enable gtk gprompter) \
		$(use_enable gtk gpresagemate) \
		$(use_enable examples curses) \
		$(use_enable python) \
		$(use_enable python python-binding) \
		$(use_enable sqlite) \
		$(use_enable test)
}
