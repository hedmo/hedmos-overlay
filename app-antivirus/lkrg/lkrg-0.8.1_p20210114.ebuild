# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-mod linux-info

DESCRIPTION="Linux Kernel Runtime Guard"
HOMEPAGE="https://www.openwall.com/lkrg/"
COMMIT="8814ebe8043d3ff4d7efbb00baacebe6a73bd8f4"
SRC_URI="https://github.com/openwall/lkrg/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"

KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}/${PN}-${COMMIT}"

MODULE_NAMES="p_lkrg(misc:${S}:${S})"
BUILD_TARGETS="clean all"
CONFIG_CHECK="
	JUMP_LABEL
	FTRACE
	DYNAMIC_FTRACE
	FUNCTION_TRACER
"

pkg_setup() {
	linux-mod_pkg_setup
	#compile against selected (not running) target
	BUILD_PARAMS="P_KVER=${KV_FULL} P_KERNEL=${KERNEL_DIR}"
}

pkg_postinst() {
	einfo "\nUsage:"
	einfo "\n    ~$ modprobe p_lkrg p_init_log_level=3\n"
	}
