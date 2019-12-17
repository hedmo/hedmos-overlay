# Copyright 2008 Saleem Abdulrasool <compnerd@compnerd.org>
# Distributed under the terms of the GNU General Public License v2

require gnome.org
require autotools [ supported_autoconf=[ 2.5 ] supported_automake=[ 1.15 ] ]

SUMMARY="Window Navigator Construction Key Library"
HOMEPAGE="http://www.gnome.org/"

LICENCES="LGPL-2"
SLOT="1"
PLATFORMS="~amd64 ~x86"
MYOPTIONS="doc gobject-introspection"

DEPENDENCIES="
    build:
        dev-util/intltool[>=0.40.0]
        virtual/pkg-config[>=0.20]
        doc? ( dev-doc/gtk-doc[>=1.9] )
        gobject-introspection? ( gnome-desktop/gobject-introspection[>=0.6.14] )
    build+run:
        dev-libs/glib:2[>=2.16.0]
        x11-libs/gtk+:2[>=2.19.7]
        x11-libs/libX11
        x11-libs/libXext
        x11-libs/libXres
        x11-libs/startup-notification[>=0.4]
"

DEFAULT_SRC_CONFIGURE_PARAMS=( '--enable-startup-notification' '--program-suffix=-1' )
DEFAULT_SRC_CONFIGURE_OPTION_ENABLES=( 'doc gtk-doc' 'gobject-introspection introspection' )
DEFAULT_SRC_COMPILE_PARAMS=( 'GETTEXT_PACKAGE=libwnck-1' )

src_prepare() {
    edo sed -i '/AC_PATH_PROG(PKG_CONFIG/d' configure.ac
    edo sed -e 's/GNOME_DEBUG_CHECK/dnl &/'             \
            -e 's/GNOME_COMPILE_WARNINGS/dnl &/'        \
            -e 's/GNOME_MAINTAINER_MODE_DEFINES/dnl &/' \
            -i "${WORK}/configure.ac"
    edo intltoolize --automake --force --copy
    autotools_src_prepare
}
