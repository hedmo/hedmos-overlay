# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{3_6,3_7} ) # 3.4 needs to be tested

inherit python-single-r1  cmake eutils  gnome2-utils toolchain-funcs 

DESCRIPTION="OpenGL window and compositing manager"
HOMEPAGE="http://www.compiz.org/"
SRC_URI="https://launchpad.net/compiz/0.9.14/0.9.14.1/+download/compiz-0.9.14.1.tar.xz"

KEYWORDS="*"
LICENSE="GPL-2 LGPL-2.1 MIT"
SLOT="0.9"

IUSE="+cairo debug dbus fuse gnome gtk  +svg test"

S="${WORKDIR}/${PN}-${PV}"

COMMONDEPEND="
		dev-libs/boost
		dev-libs/glib:2
		dev-cpp/glibmm
		dev-libs/libxml2
		dev-libs/libxslt
		dev-python/pyrex
		dev-libs/protobuf
		media-libs/libpng
		x11-base/xorg-server
		x11-libs/libX11
		x11-libs/libXcomposite
		x11-libs/libXdamage
		x11-libs/libXext
		x11-libs/libXrandr
		x11-libs/libXrender
		x11-libs/libXinerama
		x11-libs/libICE
		x11-libs/libSM
		x11-libs/startup-notification
		virtual/opengl
		virtual/glu
		cairo? ( x11-libs/cairo[X] )
		fuse? ( sys-fs/fuse )
		gtk? (
		>=x11-libs/gtk+-2.18.0
		>=x11-libs/libwnck-3.19.4
		x11-libs/pango
		gnome? (
			gnome-base/gnome-desktop
			gnome-base/gconf
			x11-wm/metacity
				)
		)
		svg? (
				gnome-base/librsvg:2
				x11-libs/cairo
		)
		dbus? ( sys-apps/dbus )"

DEPEND="${COMMONDEPEND}
                
		app-admin/chrpath
		virtual/pkgconfig
		test? (
				dev-cpp/gtest
		)"

RDEPEND="${COMMONDEPEND}
		dev-python/pygtk
		x11-apps/mesa-progs
		x11-apps/xvinfo
		x11-themes/hicolor-icon-theme"

# TODO:
# - Remove automagic dependency for coverage report generation tools
# - Fix Xig-0 automagic resolving('CMake Warning at tests/integration/xig/CMakeLists.txt:30 (message): Xig not found, you will not be able to run X Server integration tests')
# - Check proper compilation with missing gettext/intltool
# - CFLAGS are NOT respected, this needs to be fixed
# - Default decorator exec command in ccsm is bad
# - Check all dependencies once more
# - Check CMakeFiles.txt this subdirectories :
# cmake - ?
# src
# compizconfig
# plugins
# tests - ?

pkg_pretend() {
		if [[ ${MERGE_TYPE} != binary ]]; then
			[[ $(gcc-major-version) -lt 4 ]] || \
			(	[[ $(gcc-major-version) -eq 4 && $(gcc-minor-version) -lt 6 ]] ) \
			&& die "Sorry, but gcc 4.6 or higher is required."
		fi
}


src_prepare() {


#		echo "gtk/gnome/compiz-wm.desktop.in" >> "${S}/po/POTFILES.skip"
#		echo "metadata/core.xml.in" >> "${S}/po/POTFILES.skip"

# Fix wrong path for icons
		sed -i 's:DataDir = "@prefix@/share":DataDir = "/usr/share":' compizconfig/ccsm/ccm/Constants.py.in
# disable byte-compilation
#    > py-compile

# Use Python 3
		find -type f \( -name 'CMakeLists.txt' -or -name '*.cmake' \) -exec sed -e 's/COMMAND python/COMMAND python3/g' -i {} \;
		find compizconfig/ccsm -type f -exec sed -e 's|^#!.*python|#!/usr/bin/env python3|g' -i {} \;
# Don't let compiz install /etc/compizconfig/config, violates sandbox and we install it from "${WORKDIR}/debian/compizconfig" anyway #
	#sed '/add_subdirectory (config)/d' \
	#	-i compizconfig/libcompizconfig/CMakeLists.txt || die

	# Fix libdir #
	sed "s:/lib/:/$(get_libdir)/:g" \
		-i compizconfig/compizconfig-python/CMakeLists.txt || die

	# Unset CMAKE_BUILD_TYPE env variable so that cmake-utils.eclass doesn't try to "append-cppflags -DNDEBUG" #
	#	resulting in compiz window placement not working #
	#export CMAKE_BUILD_TYPE=none

	# Disable -Werror #
	sed -e 's:-Werror::g' \
		-i cmake/CompizCommon.cmake || die		
		
		
# Gentoo 'cython3' binary is called 'cython' #
	sed -e 's:cython3:cython:g' \
		-i compizconfig/compizconfig-python/CMakeLists.txt || die
		
		
# Need to do a 'python_foreach_impl' run from python-r1 eclass to workaround corrupt generated python shebang for /usr/bin/ccsm #
	#  Due to the way CMake invokes distutils setup.py, shebang will be inherited from the sandbox leading to runtime failure #
	python_copy_sources
	cmake_src_prepare
	
	
}


src_configure() {
BUILD_DIR=${WORKDIR}/build
local mycmakeargs=(
"$(cmake-utils_use_use gnome GCONF)"
"$(cmake-utils_use_use gnome GNOME)"
"$(cmake-utils_use_use gnome GSETTINGS)"
"$(cmake-utils_use_use gtk GTK)"
"$(cmake-utils_use_use gtk CCSM)"
"$(cmake-utils_use test COMPIZ_BUILD_TESTING)"
"-DCMAKE_INSTALL_PREFIX=/usr"
"-DCMAKE_C_FLAGS=$(usex debug '-DDEBUG -ggdb' '')"
"-DCMAKE_CXX_FLAGS=$(usex debug '-DDEBUG -ggdb' '')"
"-DCOMPIZ_DEFAULT_PLUGINS=composite,opengl,decor,resize,place,move,compiztoolbox,staticswitcher,regex,animation,wall,ccp"
"-DCOMPIZ_DISABLE_SCHEMAS_INSTALL=ON"
"-DCOMPIZ_PACKAGING_ENABLED=ON"
"-DCOMPIZ_WERROR=Off"
"-HAVE_WNCK_WINDOW_HAS_NAME=1"
"-Wno-dev=ON"

)
cmake_src_configure
}

src_install() {
	pushd "${CMAKE_BUILD_DIR}"
	# Fix paths to avoid sandbox access violation
	# 'emake DESTDIR=${D} install' does not work with compiz cmake files!
	for i in `find . -type f -name "cmake_install.cmake"`;do
	sed -e "s|/usr|${D}/usr|g" -i "${i}"  || die "sed failed"
	sed -e "s|/etc|${D}/etc|g" -i "${i}"  || die "sed failed"
        done
	emake install
	popd
}

pkg_preinst() {
	use gnome && gnome2_gconf_savelist
}

pkg_postinst() {
	use gnome && gnome2_gconf_install
	if use dbus; then
	ewarn "The dbus plugin is known to crash compiz in this version. Disable"
	ewarn "it if you experience crashes when plugins are enabled/disabled."
	fi
}

pkg_prerm() {
	use gnome && gnome2_gconf_uninstall
}
