# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="my virtual to have all my kernel in one ebuild"

SLOT="0"
KEYWORDS="amd64 arm x86"
IUSE="hedmo t30 xanmod stable"
REQUIRED_USE=""


RDEPEND="
	hedmo? ( sys-kernel/hedmos-kernel )
	t30? ( sys-kernel/t30-kernel )
	xanmod? ( sys-kernel/xanmod-kernel )
	stable? ( <=sys-kernel/hedmos-kernel-6.0.99 )
"
