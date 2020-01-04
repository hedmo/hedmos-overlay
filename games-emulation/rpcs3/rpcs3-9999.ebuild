
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils
#eutils pax-utils toolchain-funcs flag-o-matic

if [[ ${PV} == 9999 ]]
then
	EGIT_REPO_URI="https://github.com/RPCS3/rpcs3"
	inherit git-r3
else
	SRC_URI="https://github.com/RPCS3/rpcs3/archive/v${PV}.tar.gz"
	KEYWORDS="~amd64"
fi

DESCRIPTION="Very experimental PS3 emulator"
HOMEPAGE="https://rpcs3.net http://www.emunewz.net/forum/forumdisplay.php?fid=172"

LICENSE="GPL-2"
SLOT="0"
IUSE="alsa gdb joystick +llvm +llvmsub pulseaudio +z3 +test  vulkan"

CDEPEND="
        vulkan? ( media-libs/vulkan-loader[wayland] )
"

RDEPEND="${CDEPEND}
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	alsa? ( media-libs/alsa-lib )
	gdb? ( sys-devel/gdb )
	joystick? ( dev-libs/libevdev )
	llvm? ( sys-devel/llvm )
        media-libs/glew:0
	media-libs/libpng:*
	media-libs/openal
	pulseaudio? ( media-sound/pulseaudio )
	sys-libs/zlib
	virtual/ffmpeg
	virtual/opengl
	x11-libs/libX11
        z3? ( sci-mathematics/z3 )
        test? ( dev-cpp/gtest )
        vulkan? ( media-libs/vulkan-loader )

"
#
#DEPEND="${RDEPEND}
#	>=sys-devel/gcc-5.1
#"


src_prepare() {
	default

	sed -i -e '/find_program(CCACHE_FOUND/d' CMakeLists.txt

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		"-DUSE_SYSTEM_LIBPNG=ON"
		"-DUSE_SYSTEM_FFMPEG=ON"
		"-DUSE_VULKAN=$(usex vulkan ON OFF)"
		"-DUSE_ALSA=$(usex alsa ON OFF)"
		"-DUSE_PULSE=$(usex pulseaudio ON OFF)"
		"-DUSE_LIBEVDEV=$(usex joystick ON OFF)"
		"-DWITH_GDB=$(usex gdb ON OFF)"
		"-DWITH_LLVM=$(usex llvm ON OFF)"
                "-DBUILD_LLVM_SUBMODULE=$(usex llvmsub ON OFF)"
                "-Wno-dev=ON"


	)
        CCACHE_SLOPPINESS=pch_defines,time_macros
        CMAKE_BUILD_TYPE=Release
	cmake-utils_src_configure
}

#pkg_postinst() {
	# Add pax markings for hardened systems
#	pax-mark -m "${EPREFIX}"/usr/bin/"${PN}"
#}
