# Copyright 1999-2011 Gentoo Foundation
       # Distributed under the terms of the GNU General Public License v2
       #$Header:/var/cvsroot/gentoo-x86/x11-libs/libwnck/libwnck-2.30.7.ebuild,v1.6 2011/10/28 20:22:46 maekke Exp $
 	EAPI="5"
 	GNOME2_LA_PUNT="yes"
 	GCONF_DEBUG="no"
 	
	inherit gnome2
 	
 	DESCRIPTION="A window navigation construction kit"
 	HOMEPAGE="http://www.gnome.org/"
 	
 	LICENSE="LGPL-2"
 	SLOT="1"
 	KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sh sparc x86 ~x86-fbsd  ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-solaris ~x86-solaris"
 	
 	IUSE="doc +introspection startup-notification"
 	
 	RDEPEND=">=x11-libs/gtk+-2.19.7:2[introspection?]
 	>=dev-libs/glib-2.16:2
 	x11-libs/libX11
 	x11-libs/libXres
 	x11-libs/libXext
 	introspection? ( >=dev-libs/gobject-introspection-0.6.14 )
 	startup-notification? ( >=x11-libs/startup-notification-0.4 )"
 	DEPEND="${RDEPEND}
 	sys-devel/gettext
 	>=dev-util/pkgconfig-0.9
 	>=dev-util/intltool-0.40
 	doc? ( >=dev-util/gtk-doc-1.9 )
 	# eautoreconf needs
 	# dev-util/gtk-doc-am
 	# gnome-base/gnome-common
 	
 	pkg_setup() {
 	G2CONF="${G2CONF}
 	--disable-static
 	$(use_enable introspection)
 	$(use_enable startup-notification)"
 	DOCS="AUTHORS ChangeLog HACKING NEWS README"
 	}
 	
 	src_prepare() {
 	gnome2_src_prepare
 	}	
