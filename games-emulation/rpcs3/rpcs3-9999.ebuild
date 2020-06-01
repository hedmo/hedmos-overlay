# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Very experimental PS3 emulator"
HOMEPAGE="https://rpcs3.net http://www.emunewz.net/forum/forumdisplay.php?fid=172"

inherit cmake-utils git-r3

if [[ ${PV} == 9999 ]]
then
	EGIT_REPO_URI="https://github.com/RPCS3/rpcs3"
else
	EGIT_REPO_URI="https://github.com/RPCS3/rpcs3.git"
EGIT_COMMIT="v${PV}"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="alsa faudio pulseaudio gdb joystick +llvm -system-llvm discord-rpc pulseaudio +z3 vulkan"

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
		vulkan? ( media-libs/vulkan-loader )

"

src_prepare() {
	default

	sed -i -e '/find_program(CCACHE_FOUND/d' CMakeLists.txt

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		"-DUSE_SYSTEM_ZLIB=ON"
		"-DUSE_SYSTEM_LIBPNG=ON"
		"-DUSE_SYSTEM_FFMPEG=ON"
		"-DUSE_VULKAN=$(usex vulkan ON OFF)"
		"-DUSE_ALSA=$(usex alsa ON OFF)"
		"-DUSE_FAUDIO=$(usex faudio ON OFF)"
		"-DUSE_DISCORD_RPC=$(usex discord-rpc ON OFF)"
		"-DUSE_PULSE=$(usex pulseaudio ON OFF)"
		"-DUSE_LIBEVDEV=$(usex joystick ON OFF)"
		"-DWITH_GDB=$(usex gdb ON OFF)"
		"-DWITH_LLVM=$(usex llvm ON OFF)"
		"-DBUILD_LLVM_SUBMODULE=$(usex system-llvm OFF ON)"
		"-Wno-dev=ON"

	)
	CCACHE_SLOPPINESS=pch_defines,time_macros
	CMAKE_BUILD_TYPE=Release
	cmake-utils_src_configure
}
