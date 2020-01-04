# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

inherit autotools eutils xdg-utils git-r3 flag-o-matic

DESCRIPTION="Emerald Window Decorator"
HOMEPAGE="https://github.com/compiz-reloaded"
EGIT_REPO_URI="https://github.com/hedmo/emerald.git"



LICENSE="GPL-2+"
SLOT="0"
IUSE="gtk3"

PDEPEND="x11-themes/emerald-themes"

RDEPEND="
	x11-wm/compiz
	gtk3? (
		x11-libs/gtk+:3
		x11-libs/libwnck:3
	)
	!gtk3? (
		>=x11-libs/gtk+-2.22.0:2
		>=x11-libs/libwnck-2.22:1
	)
"

DEPEND="${RDEPEND}
	>=dev-util/intltool-0.35
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
"

src_prepare() {
	# fix build with gtk+-2.22 - bug 341143
	sed -i -e '/#define G[DT]K_DISABLE_DEPRECATED/s:^://:' \
		include/emerald.h || die
	default
	intltoolize --automake --copy --force || die
	eautoreconf || die "eautoreconf failed"
	append-ldflags -Wl,-lm,-ldl
}

src_configure() {
	econf \
		--disable-static \
		--enable-fast-install \
		--disable-mime-update \
		--with-gtk=$(usex gtk3 3.0 2.0)
}

src_install() {
	default
	prune_libtool_files
}

pkg_postinst() { 
        xdg_desktop_database_update 
        xdg_mimeinfo_database_update
} 

pkg_postrm() { 
        xdg_desktop_database_update 
        xdg_mimeinfo_database_update
}
