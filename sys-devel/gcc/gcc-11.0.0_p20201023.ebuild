# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit toolchain

DESCRIPTION="The GNU Compiler Collection"
HOMEPAGE="https://gcc.gnu.org/"

GCC_URI="https://github.com/gcc-mirror/gcc/archive"
COMMIT="43868df37b0e1fa19c32175b41dd7dc1e7c515fd"
PATCH_GCC_URI="https://dev.gentoo.org/~slyfox/distfiles"
PATCH_GCC_VER="11.0.0"
PATCH_VER="4"

SRC_URI="${GCC_URI}/${COMMIT}.tar.gz -> ${P}.tar.gz
${PATCH_GCC_URI}/gcc-${PATCH_GCC_VER}-patches-${PATCH_VER}.tar.bz2"
S="${WORKDIR}"/gcc-${COMMIT}

# Don't keyword live ebuilds
#KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sh ~sparc ~x86"

RDEPEND=""
BDEPEND="${CATEGORY}/binutils"

src_prepare() {
	has_version '>=sys-libs/glibc-2.32-r1' && rm -v "${WORKDIR}/patch/23_all_disable-riscv32-ABIs.patch"
	toolchain_src_prepare
} 
