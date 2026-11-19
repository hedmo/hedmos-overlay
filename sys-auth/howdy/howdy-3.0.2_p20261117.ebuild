# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..14} )

inherit meson python-single-r1

HOWDY_COMMIT="7998959b0c36909a90619fd0904b622000df8354"
DLIB_MODELS_COMMIT="fd81b6308a6a73d4ce08859eb2f4b628a21e27a2"

DESCRIPTION="Windows Hello style IR facial authentication for Linux"
HOMEPAGE="https://github.com"
SRC_URI="
	https://github.com/boltgolt/howdy/archive/${HOWDY_COMMIT}.tar.gz
		-> ${P}.tar.gz
	https://github.com/davisking/dlib-models/raw/${DLIB_MODELS_COMMIT}/dlib_face_recognition_resnet_model_v1.dat.bz2
		-> howdy-dlib_face_recognition_resnet_model_v1.dat.bz2
	https://github.com/davisking/dlib-models/raw/${DLIB_MODELS_COMMIT}/mmod_human_face_detector.dat.bz2
		-> howdy-mmod_human_face_detector.dat.bz2
	https://github.com/davisking/dlib-models/raw/${DLIB_MODELS_COMMIT}/shape_predictor_5_face_landmarks.dat.bz2
		-> howdy-shape_predictor_5_face_landmarks.dat.bz2
"
S="${WORKDIR}/howdy-${HOWDY_COMMIT}/howdy"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="
	${PYTHON_DEPS}
	dev-libs/inih
	dev-libs/libevdev
	sys-libs/pam
"
RDEPEND="
	${DEPEND}
	$(python_gen_cond_dep '
		media-libs/opencv[python,${PYTHON_USEDEP}]
		sci-libs/dlib[python,${PYTHON_USEDEP}]
	')
"
BDEPEND="
	sys-devel/gettext
"

src_unpack() {
	unpack "${P}.tar.gz"
	local f
	for f in dlib_face_recognition_resnet_model_v1.dat mmod_human_face_detector.dat shape_predictor_5_face_landmarks.dat; do
		bzip2 -dc "${DISTDIR}/howdy-${f}.bz2" > "${WORKDIR}/${f}" || die
	done
}

src_configure() {
	local emesonargs=(
		-Dpam_dir="/$(get_libdir)/security"
		-Dconfig_dir="/etc/howdy"
		-Ddlib_data_dir="/usr/share/dlib-data"
		-Duser_models_dir="/etc/howdy/models"
		-Dinstall_in_site_packages=true
		-Dinstall_pam_config=false
		-Dinstall_config=true
		-Dpython_path="${PYTHON}"
	)
	meson_src_configure
}

src_install() {
	meson_src_install

	insinto /usr/share/dlib-data
	doins "${WORKDIR}/dlib_face_recognition_resnet_model_v1.dat"
	doins "${WORKDIR}/mmod_human_face_detector.dat"
	doins "${WORKDIR}/shape_predictor_5_face_landmarks.dat"

	# Default to Surface Book 3 IR loopback device /dev/video66
	if [[ -f "${ED}/etc/howdy/config.ini" ]]; then
		sed -i 's|^device_path =.*|device_path = /dev/video66|' "${ED}/etc/howdy/config.ini" || die
	fi
}

pkg_postinst() {
	elog "Configure /dev/video66 (Surface-IR-Howdy) and add your face model with:"
	elog "  sudo howdy add"
	elog "Then enable Howdy in PAM (e.g. /etc/pam.d/kde or /etc/pam.d/sudo):"
	elog "  auth sufficient pam_howdy.so"
}
