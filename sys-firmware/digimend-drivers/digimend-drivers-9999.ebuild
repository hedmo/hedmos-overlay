# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic linux-mod toolchain-funcs

DESCRIPTION="Linux kernel module for Huion and compatible tablets"
HOMEPAGE="https://github.com/DIGImend/digimend-kernel-drivers"

if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/DIGImend/digimend-kernel-drivers"
else
	SRC_URI="https://github.com/DIGImend/digimend-kernel-drivers/releases/download/v${PV}/digimend-kernel-drivers-${PV}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~ppc64"
	S="${WORKDIR}/digimend-kernel-drivers-${PV}"
fi

MODULE_NAMES="hid-kye(extra:) hid-polostar(extra:) hid-uclogic(extra:) hid-viewsonic(extra:)"

LICENSE="GPL-2+"
SLOT="0"

DEPEND=""

RDEPEND="${DEPEND}"

DOCS=( README.md )

PATCHES=(
	"${FILESDIR}/6.12.patch"
)

pkg_setup() {
	linux-mod_pkg_setup
}

src_compile() {
	set_arch_to_kernel
	myemakeargs=( V=1 modules )
	emake "${myemakeargs[@]}"
}

src_install() {
	set_arch_to_kernel
	linux-mod_src_install
	einstalldocs
}

pkg_postinst() {
	linux-mod_pkg_postinst
}

