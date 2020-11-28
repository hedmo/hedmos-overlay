
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils git-r3
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils 

COMMON_URI="
https://github.com/RPCS3/yaml-cpp/archive/6a211f0bc71920beef749e6c35d7d1bcc2447715.tar.gz
https://github.com/RPCS3/llvm-mirror/archive/8c02f52a12550c2044fef262c9864ca2e3cc193e.tar.gz
https://github.com/asmjit/asmjit/archive/fc251c914e77cd079e58982cdab00a47539d7fc5.tar.gz

https://github.com/FNA-XNA/FAudio/archive/9c7d2d1430c9dbe4e67c871dfe003b331f165412.tar.gz
https://github.com/RPCS3/cereal/archive/60c69df968d1c72c998cd5f23ba34e2e3718a84b.tar.gz
https://github.com/curl/curl/archive/9d954e49bce3706a9a2efb119ecd05767f0f2a9e.tar.gz
https://github.com/RPCS3/ffmpeg-core/archive/e5fb13bbb07ac3ba2e1998e2f5688f3714870d93.tar.gz
https://github.com/RPCS3/hidapi/archive/9220f5e77c27b8b3717b277ec8d3121deeb50242.tar.gz
https://github.com/glennrp/libpng/archive/eddf9023206dc40974c26f589ee2ad63a4227a1e.tar.gz
https://github.com/libusb/libusb/archive/c33990a300674e24f47ff0f172f7efb10b63b88a.tar.gz
https://github.com/zeux/pugixml/archive/8bf806c035373bd0723a85c0820cfd5c804bf6cd.tar.gz
https://github.com/tcbrindle/span/archive/9d7559aabdebf569cab3480a7ea2a87948c0ae47.tar.gz
https://github.com/wolfSSL/wolfssl/archive/39b5448601271b8d1deabde8a0d33dc64d2a94bd.tar.gz
https://github.com/Cyan4973/xxHash/archive/94e5f23e736f2bb67ebdf90727353e65344f9fc0.tar.gz
https://github.com/RPCS3/yaml-cpp/archive/6a211f0bc71920beef749e6c35d7d1bcc2447715.tar.gz
https://github.com/KhronosGroup/glslang/archive/3ee5f2f1d3316e228916788b300d786bb574d337.tar.gz
https://github.com/hedmo/spirv-headers/archive/3fdabd0da2932c276b25b9b4a988ba134eba1aa6.tar.gz
https://github.com/hedmo/spirv-tools/archive/895927bd3f2d653f40cebab55aa6c7eabde30a86.tar.gz
https://github.com/google/flatbuffers/archive/9e7e8cbe9f675123dd41b7c62868acad39188cae.tar.gz
https://github.com/madler/zlib/archive/cacf7f1d4e3d44d871b605da3b647f07d718623f.tar.gz
"

if [[ ${PV} == 9999 ]]
then
	EGIT_REPO_URI="https://github.com/RPCS3/rpcs3"
else
	SRC_URI="https://github.com/RPCS3/rpcs3/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${COMMON_URI}"

	KEYWORDS="~amd64"
fi

DESCRIPTION="Very experimental PS3 emulator"
HOMEPAGE="https://rpcs3.net http://www.emunewz.net/forum/forumdisplay.php?fid=172"

LICENSE="GPL-2"
SLOT="0"
IUSE="alsa faudio gdb joystick +llvm -system-llvm discord-rpc pulseaudio +z3 +test vulkan"

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
	>=media-video/ffmpeg-3.1.3:0
	virtual/opengl
	x11-libs/libX11
	z3? ( sci-mathematics/z3 )
	test? ( dev-cpp/gtest )
	vulkan? ( media-libs/vulkan-loader )
"


src_prepare() {
	move_lib() {
		local IN_DIR="${1}"
		local OUT_DIR
		[ -z "${2}" ] && OUT_DIR="${IN_DIR}" || OUT_DIR="${2%/}/${IN_DIR}"
	mv "${WORKDIR}/${IN_DIR}"*/* "${S}/${OUT_DIR}" || die
   }

	move_lib asmjit
	move_lib llvm
	move_lib glslang Vulkan
	move_lib spirv-tools Vulkan
	move_lib spirv-headers Vulkan
	local thirdparty_libs=" cereal curl FAudio ffmpeg hidapi libpng libusb pugixml span wolfssl xxHash yaml-cpp flatbuffers zlib " 
	for thirdparty_lib in ${thirdparty_libs} ; do
	move_lib "${thirdparty_lib}" 3rdparty
	 done

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
	CACHE_SLOPPINESS=pch_defines,time_macros
	CMAKE_BUILD_TYPE=Release
	cmake-utils_src_configure
}




if [[ ${PV} == 9999 ]]
then
	EGIT_REPO_URI="https://github.com/RPCS3/rpcs3"
else
	EGIT_REPO_URI="https://github.com/RPCS3/rpcs3.git"
EGIT_COMMIT="v${PV}"
	KEYWORDS="~amd64"
fi

DESCRIPTION="Very experimental PS3 emulator"
HOMEPAGE="https://rpcs3.net http://www.emunewz.net/forum/forumdisplay.php?fid=172"

LICENSE="GPL-2"
SLOT="0"
IUSE="alsa faudio pulseaudio gdb joystick +llvm -system-llvm discord-rpc pulseaudio +z3 +test vulkan"

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

#pkg_postinst() {
	# Add pax markings for hardened systems
#	pax-mark -m "${EPREFIX}"/usr/bin/"${PN}"
#}
