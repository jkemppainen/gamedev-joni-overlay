# Copyright 2020-2024 Joni Kemppainen
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8,9,10,11,12,13} )
inherit distutils-r1

DESCRIPTION="A 3D rendering framework for Python and C++ programs."
HOMEPAGE="https://www.panda3d.org/"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm64"
IUSE="+cg +eigen +gtk2 +jpeg +openal openexr +png +python ssl tiff +truetype vorbis X zlib
	assimp opus egl ffmpeg gles1 gles2 bullet ode opencv fftw
	+direct +opengl tinydisplay swscale swresample
	+pandaphysics +egg +harfbuzz directcam vision wxwidgets fltk
	pview pandatool deploytools skel +pandafx +pandaparticlesystem
	contrib"

ARM_CPU_FEATURES=(
	cpu_flags_arm_neon:neon
)
X86_CPU_FEATURES=(
	cpu_flags_x86_sse2:sse2
)
IUSE="${IUSE}
	${ARM_CPU_FEATURES[@]%:*}
	${X86_CPU_FEATURES[@]%:*}"


REQUIRED_USE="swscale? ( ffmpeg )
	swresample? ( ffmpeg )"

RDEPEND="cg? ( media-gfx/nvidia-cg-toolkit )
	eigen? ( dev-cpp/eigen )
	gtk2? ( x11-libs/gtk+ )
	jpeg? ( virtual/jpeg )
	openal? ( media-libs/openal )
	openexr? ( media-libs/openexr )
	png? ( media-libs/libpng )
	python? ( ${PYTHON_DEPS} )
	ssl? ( dev-libs/openssl )
	tiff? ( media-libs/tiff )
	truetype? ( media-libs/freetype )
	vorbis? ( media-libs/libvorbis )
	X? ( x11-base/xorg-proto )
	zlib? ( sys-libs/zlib )
	assimp? ( media-libs/assimp )
	opus? ( media-libs/opus )
	ffmpeg? ( media-video/ffmpeg )
	swscale? ( media-video/ffmpeg )
	swresample? ( media-video/ffmpeg )
	bullet? ( sci-physics/bullet )
	ode? ( dev-games/ode )
	opencv? ( media-libs/opencv )
	fftw? ( sci-libs/fftw )
	harfbuzz? ( media-libs/harfbuzz )
	fltk? ( x11-libs/fltk )
	wxwidgets? ( x11-libs/wxGTK )"
DEPEND="${RDEPEND} sys-devel/bison sys-devel/flex"
BDEPEND="${RDEPEND}"

src_compile() {
	# ------------------------------------
	# TWO HELPER FUNCTIONS
	# ------------------------------------
	# Echoes --use-$2 if (usev $1)==True
	function pandause {
		usepanda=$(usev $1)
		if [ $usepanda ]; then
			state="use"
		else
			state="no"
		fi

		if [ "$2" ]; then
			name=$2
		else
			name=$1
		fi
		echo "--$state-$name"
	}
	# Parses Gentoo's MAKEOPTS for the number of
	# parallel jobs
	function parsejobs {
		TOPARSING=$@
		JOBS="1"
		for piece in ${TOPARSING[@]}
		do
				if [ $JOBS = "next" ];
				then
						JOBS=$piece
						break
				fi
				if [ ${piece:0:2} = "-j" ] && [[ ${piece:2} =~ ^[0-9]+$ ]];
				then
						JOBS=${piece:2}
						break
				fi
				if [ $piece = "--jobs" ];
				then
						JOBS="next"
				fi
		done
		echo $JOBS
	}

	# ------------------------------------
	# SOURCE COMPLIE
	# ------------------------------------

	usenvidiacg=$(usev "cg")
	if [ $usenvidiacg ];
	then
		mkdir "thirdparty"
		mkdir "thirdparty/linux-libs-x64/"
		mkdir "thirdparty/linux-libs-x64/nvidiacg"
		mkdir "thirdparty/linux-libs-x64/nvidiacg/include"
		mkdir "thirdparty/linux-libs-x64/nvidiacg/include/Cg"
		mkdir "thirdparty/linux-libs-x64/nvidiacg/lib"
		cp "/opt/nvidia-cg-toolkit/include/Cg/cg.h" "thirdparty/linux-libs-x64/nvidiacg/include/Cg/cg.h"
		cp "/opt/nvidia-cg-toolkit/include/Cg/cgGL.h" "thirdparty/linux-libs-x64/nvidiacg/include/Cg/cgGL.h"
		cp "/opt/nvidia-cg-toolkit/lib64/libCg.so" "thirdparty/linux-libs-x64/nvidiacg/lib/libCg.so"
		cp "/opt/nvidia-cg-toolkit/lib64/libCgGL.so" "thirdparty/linux-libs-x64/nvidiacg/lib/libCgGL.so"
	fi

	PANDAOPTS=(
		$(pandause "cg" "nvidiacg")
		$(pandause "eigen")
		$(pandause "gtk2")
		$(pandause "jpeg")
		$(pandause "openal")
		$(pandause "openexr")
		$(pandause "png")
		$(pandause "python")
		$(pandause "ssl" "openssl")
		$(pandause "tiff")
		$(pandause "truetype" "freetype")
		$(pandause "vorbis")
		$(pandause "X" "x11")
		$(pandause "zlib")
		$(pandause "assimp")
		$(pandause "opus")
		$(pandause "ffmpeg")
		$(pandause "bullet")
		$(pandause "ode")
		$(pandause "gles1" "gles")
		$(pandause "gles2" "gles")
		$(pandause "opencv")
		$(pandause "fftw")
		$(pandause "direct")
		$(pandause "opengl" "gl")
		$(pandause "tinydisplay")
		$(pandause "swscale")
		$(pandause "swresample")
		$(pandause "harfbuzz")
		$(pandause "directcam")
		$(pandause "vision")
		$(pandause "wxwidgets" "wx")
		$(pandause "fltk")
		$(pandause "pandatool")
		$(pandause "pview")
		$(pandause "deploytools")
		$(pandause "skel")
		$(pandause "pandafx")
		$(pandause "pandaparticlesystem")
		$(pandause "contrib")
		#
		# No ebuilds available for these 3rd party packages yet
		#
		"--no-artoolkit"
		"--no-fcollada"
		"--no-fmodex"
		"--no-squish"
		"--no-vrpn"
		"--no-rocket"
		#
		# CPU Optimization flags
		#
		$(pandause "cpu_flags_x86_sse2" "sse2")
		$(pandause "cpu_flags_arm_neon" "neon")
	)
	elog "Building Panda3D using the following options"
	elog ${PANDAOPTS[*]}

	# Execute makepanda
	./makepanda/makepanda.py ${PANDAOPTS[*]} \
		--threads $(parsejobs $MAKEOPTS) || die "Build (makepanda.py) failed!"
}


python_install()
{
	# Let's install Panda3D to /opt for now at least
	dodir /opt/panda3d
	cp -R ${S}/built/* ${D}/opt/panda3d

	# Make symbolic links to Panda for Python
	pthdir="${D}$(python_get_sitedir)"
	dodir $(python_get_sitedir)

	ln -s /opt/panda3d/panda3d "${pthdir}/panda3d"
	ln -s /opt/panda3d/direct "${pthdir}/direct"
	ln -s /opt/panda3d/pandac "${pthdir}/pandac"

	# Add pandas lib to the path of shared libraries
	echo "LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:/opt/panda3d/lib/" >> 50panda3d
	doenvd 50panda3d

	# Entry points for build_apps and bdist_apps commands
	# (for distributing Panda3D applications)
	usedeploy=$(usev "deploytools")
	if [ $usedeploy ]; then
		ln -s "/opt/panda3d/panda3d.dist-info" "${pthdir}/panda3d.dist-info"
	fi


}
