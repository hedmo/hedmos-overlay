# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
EGIT_REPO_URI="https://github.com/ValveSoftware/openvr"

if [[ ${PV} = 9999* ]]; then
	GIT_ECLASS="git-r3"
	EXPERIMENTAL="true"
fi

inherit cmake-multilib ${GIT_ECLASS}

DESCRIPTION="OpenVR SDK"
HOMEPAGE="https://steamvr.com"

if [[ $PV == 9999* ]]; then
	SRC_URI=""
else
	SRC_URI="${EGIT_REPO_URI}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="BSD"
SLOT="0"
IUSE="static"

RDEPEND="
"
DEPEND="${RDEPEND}"

PATCHES=(
    "${FILESDIR}/${PN}-libdir.patch"
)

src_configure() {
	my_configure() {
		mycmakeargs=(
			-DBUILD_SHARED="$(usex static OFF ON)"
		)
		cmake-utils_src_configure
	}
	multilib_parallel_foreach_abi my_configure
}
