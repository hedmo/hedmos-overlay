# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="A free software virtual keyboard for Linux based on Maliit framework"
HOMEPAGE="https://maliit.github.io/"
SRC_URI="https://github.com/${PN/-/\/}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="~amd64"

IUSE="anthy chewing hunspell pinyin presage"

S="${WORKDIR}"/${P#maliit-}

BDEPEND="sys-devel/gettext"

DEPEND="
	dev-libs/glib
	=dev-qt/qtfeedback-5*
	dev-qt/qtmultimedia:5
	x11-misc/maliit-framework
	anthy? ( app-i18n/anthy )
	chewing? ( app-i18n/libchewing )
	hunspell? ( app-text/hunspell )
	pinyin? ( app-i18n/libpinyin )
	presage? ( app-text/presage )"

RDEPEND="${DEPEND}"

src_prepare() {
	cmake_src_prepare

	sed -e "s|if(Anthy_FOUND)|if($(use anthy && echo 1 || echo 0))|" \
		-e "s|if(Pinyin_FOUND)|if($(use pinyin && echo 1 || echo 0))|" \
		-e "s|if(Chewing_FOUND)|if($(use chewing && echo 1 || echo 0))|" \
		-e "s|doc/maliit-keyboard|doc/${PF}|" \
		-i CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-Denable-hunspell=$(usex hunspell)
		-Denable-presage=$(usex presage)
	)
	cmake_src_configure
}
