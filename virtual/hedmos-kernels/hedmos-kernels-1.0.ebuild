# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Virtual for Wine that supports multiple variants and slotting"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE="hedmo t30 xanmod"
REQUIRED_USE=""


RDEPEND="
	hedmo? ( sys-kernel/hedmos-kernel )
	t30? ( sys-kernel/t30-kernel )
	xanmod? ( sys-kernel/xanmod-kernel )
"
