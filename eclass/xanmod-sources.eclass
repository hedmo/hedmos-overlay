# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: xanmod.eclass
# @MAINTAINER:
# Alfred Wingate <parona@protonmail.com>
# @AUTHOR:
# Alfred Wingate <parona@protonmail.com>
# @SUPPORTED_EAPIS: 8
# @BLURB: Helper eclass for XanMod ebuilds
# @DESCRIPTION:
# Eclass for XanMod specific actions and variables.

if [[ ! ${_XANMOD_ECLASS} ]]; then

case ${EAPI} in
	8) ;;
	*) die "${ECLASS}: EAPI ${EAPI} unsupported."
esac

_XANMOD_ECLASS=1

# @ECLASS-VARIABLE: K_SECURITY_UNSUPPORTED
# @INTERNAL
# @DESCRIPTION:
#

# @ECLASS-VARIABLE: K_NOUSEPV
# @INTERNAL
# @DESCRIPTION:
#

# @ECLASS-VARIABLE: K_NOSETEXTRAVERSION
# @INTERNAL
# @DESCRIPTION:
#

# @ECLASS-VARIABLE: ETYPE
# @INTERNAL
# @DESCRIPTION:
#

# @ECLASS-VARIABLE: XANMOD_BASE_URI
# @DESCRIPTION:
# Base URI which is used for XANMOD_URI.
# Default is https://github.com/xanmod/linux/releases/download/

# @ECLASS-VARIABLE: XANMOD_URI
# @OUTPUT_VARIABLE
# @DESCRIPTION:
# URI of the xanmod sources

# @ECLASS-VARIABLE: XANMOD_EDITION
# @PRE_INHERIT
# @DEFAULT_UNSET
# @REQUIRED
# @DESCRIPTION:
# Specifies edition of xanmod sources that are fetched

K_SECURITY_UNSUPPORTED=1
K_NOUSEPV=1
K_NOSETEXTRAVERSION=1
ETYPE="sources"

inherit kernel-2
detect_version

HOMEPAGE="https://xanmod.org"

XANMOD_BASE_URI="https://github.com/xanmod/linux/releases/download/"

case ${XANMOD_EDITION} in
        stable|edge|lts)
                DESCRIPTION="Full XanMod sources including the Gentoo patchset"
                SLOT="${PVR}/${XANMOD_EDITION}"
                XANMOD_URI="${XANMOD_BASE_URI}/${OKV}-xanmod${XANMOD_VERSION}/patch-${OKV}-xanmod${XANMOD_VERSION}.xz"
                ;;
        rt)
                DESCRIPTION="Full XanMod sources including CONFIG_PREEMPT_RT and the Gentoo patchset"
                XANMOD_URI="${XANMOD_BASE_URI}/${OKV}-rt$(ver_cut 5)-xanmod${XANMOD_VERSION}/patch-${OKV}-rt$(ver_cut 5)-xanmod${XANMOD_VERSION}.xz"
				;;
		*)
				DESCRIPTION="Full XanMod sources including ${XANMOD_EDITION} and the Gentoo patchset"
                XANMOD_URI="${XANMOD_BASE_URI}/${OKV}-xanmod${XANMOD_VERSION}-${XANMOD_EDITION}/patch-${OKV}-xanmod${XANMOD_VERSION}-${XANMOD_EDITION}.xz"
                ;;
esac

# @FUNCTION: xanmod-sources_pkg_postinst
# @DESCRIPTION:
# Default phase actions which adds Microcode related information with regular kernel-2_pkg_postinst
xanmod-sources_pkg_postinst() {
        kernel-2_pkg_postinst
        elog "MICROCODES"
        elog "Use ${PN} with microcodes"
        elog "Read https://wiki.gentoo.org/wiki/Intel_microcode"
}

EXPORT_FUNCTIONS pkg_postinst
fi
 
