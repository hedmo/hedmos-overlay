# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/emerald/emerald-0.8.4-r2.ebuild,v 1.4 2011/09/14 20:47:24 ssuominen Exp $

EAPI="3"

inherit  autotools flag-o-matic
#eutils 

THEMES_RELEASE=0.5.2

DESCRIPTION="Emerald Window Decorator"
HOMEPAGE="http://www.compiz.org/"
SRC_URI="http://cgit.compiz.org/fusion/decorators/emerald/snapshot/emerald-0.9.5.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

# NOTE: emerald-0.9.5 can not bee downloaden as it chould.
RESTRICT="fetch strip"


PDEPEND="~x11-themes/emerald-themes-${THEMES_RELEASE}"

RDEPEND="
	>=x11-libs/gtk+-2.8.0:2
	>=x11-libs/libwnck-2.30.7
	>=x11-wm/compiz-${PV}
"

DEPEND="${RDEPEND}
	>=dev-util/intltool-0.35
	>=dev-util/pkgconfig-0.19
	>=sys-devel/gettext-0.15
"



 pkg_nofetch() {
	echo
	eerror "Please go to: http://cgit.compiz.org/fusion/decorators/emerald/"
	eerror
	eerror "and download the emerald-0.9.5.tar.gz"
	eerror "  package for you"
	eerror "After downloading it, put the .tar.gz into:"
	eerror "  ${DISTDIR}"
	echo
}


 src_prepare() {
          intltoolize --automake --copy --force || die
           eautoreconf || die "eautoreconf failed"
          #Secure linking needed
          append-ldflags -Wl,-lm,-ldl
   }
   
   src_configure() {
           econf --disable-mime-update || die "econf failed"
   }
   
   src_install() {
           emake DESTDIR="${D}" install || die "emake install failed"
   }
  
   pkg_postinst() {
           ewarn "DO NOT report bugs to Gentoo's bugzilla"
           einfo "Please DO NOT report bugs at ALL"
	   einfo "This is a home made ebuild"  
           einfo "Thank you on behalf of Hedmo"
   }
