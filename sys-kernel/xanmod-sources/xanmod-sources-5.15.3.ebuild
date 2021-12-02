# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

K_WANT_GENPATCHES="base extras"
K_GENPATCHES_VER="2"
XANMOD_EDITION="edge"
XANMOD_VERSION="1"

inherit xanmod-sources

SRC_URI="${KERNEL_URI} ${XANMOD_URI} ${GENPATCHES_URI}"

KEYWORDS="~amd64"

