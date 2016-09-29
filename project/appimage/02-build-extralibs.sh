#!/bin/bash

# Halt on errors
set -e

# Be verbose
set -x

# Now we are inside CentOS 6
grep -r "CentOS release 6" /etc/redhat-release || exit 1

# qjsonparser, used to add metadata to the plugins needs to work in a en_US.UTF-8 environment. That's
# not always set correctly in CentOS 6.7
export LC_ALL=en_US.UTF-8
export LANG=en_us.UTF-8

# Determine which architecture should be built
if [[ "$(arch)" = "i686" || "$(arch)" = "x86_64" ]] ; then
  ARCH=$(arch)
else
  echo "Architecture could not be determined"
  exit 1
fi

# if the library path doesn't point to our usr/lib, linking will be broken and we won't find all deps either
export LD_LIBRARY_PATH=/usr/lib64/:/usr/lib:/krita.appdir/usr/lib

. /opt/rh/devtoolset-3/enable

ORIG_WD="`pwd`"

# Make sure we build from the /, parts of this script depends on that. We also need to run as root...
cd  /

# start building the deps
cd /b

rm -rf /b/* || true

cmake3 $ORIG_WD/3rdparty \
    -DCMAKE_INSTALL_PREFIX:PATH=/usr \
    -DINSTALL_ROOT=/usr \
    -DEXTERNALS_DOWNLOAD_DIR=/d


#cmake3 --build . --config RelWithDebInfo --target ext_expat -- -j4
#cmake3 --build . --config RelWithDebInfo --target ext_gettext -- -j4
#cmake3 --build . --config RelWithDebInfo --target ext_iconv -- -j4
#cmake3 --build . --config RelWithDebInfo --target ext_zlib -- -j4
#cmake3 --build . --config RelWithDebInfo --target ext_tiff -- -j4
#cmake3 --build . --config RelWithDebInfo --target ext_jpeg -- -j4
cmake3 --build . --config RelWithDebInfo --target ext_boost -- -j4
#cmake3 --build . --config RelWithDebInfo --target ext_eigen3 -- -j4
#cmake3 --build . --config RelWithDebInfo --target ext_exiv2 -- -j4
#cmake3 --build . --config RelWithDebInfo --target ext_lcms2 -- -j4
#cmake3 --build . --config RelWithDebInfo --target ext_libraw -- -j4
#cmake3 --build . --config RelWithDebInfo --target ext_opencv -- -j4
#cmake3 --build . --config RelWithDebInfo --target ext_lensfun -- -j4
#cmake3 --build . --config RelWithDebInfo --target ext_qt -- -j4
#cmake3 --build . --config RelWithDebInfo --target ext_qtwebkit -- -j4

#cmake3 --build . --config RelWithDebInfo --target ext_extra_cmake_modules -- -j4
#cmake3 --build . --config RelWithDebInfo --target ext_kconfig -- -j4
#cmake3 --build . --config RelWithDebInfo --target ext_breeze_icons -- -j4
#cmake3 --build . --config RelWithDebInfo --target ext_solid -- -j4
#cmake3 --build . --config RelWithDebInfo --target ext_kcoreaddons -- -j4
#cmake3 --build . --config RelWithDebInfo --target ext_kwindowsystem -- -j4
#cmake3 --build . --config RelWithDebInfo --target ext_solid -- -j4
#cmake3 --build . --config RelWithDebInfo --target ext_threadweaver -- -j4
#cmake3 --build . --config RelWithDebInfo --target ext_karchive -- -j4
#cmake3 --build . --config RelWithDebInfo --target ext_kdbusaddons -- -j4
#cmake3 --build . --config RelWithDebInfo --target ext_ki18n -- -j4
#cmake3 --build . --config RelWithDebInfo --target ext_kcrash -- -j4
#cmake3 --build . --config RelWithDebInfo --target ext_kcodecs -- -j4
#cmake3 --build . --config RelWithDebInfo --target ext_kauth -- -j4
#cmake3 --build . --config RelWithDebInfo --target ext_kguiaddons -- -j4
#cmake3 --build . --config RelWithDebInfo --target ext_kwidgetsaddons -- -j4
#cmake3 --build . --config RelWithDebInfo --target ext_kitemviews -- -j4
#cmake3 --build . --config RelWithDebInfo --target ext_kcompletion -- -j4
#cmake3 --build . --config RelWithDebInfo --target ext_kconfigwidgets -- -j4
#cmake3 --build . --config RelWithDebInfo --target ext_kiconthemes -- -j4
#cmake3 --build . --config RelWithDebInfo --target ext_kservice -- -j4
#cmake3 --build . --config RelWithDebInfo --target ext_kglobalaccel -- -j4
#cmake3 --build . --config RelWithDebInfo --target ext_kxmlgui -- -j4
#cmake3 --build . --config RelWithDebInfo --target ext_kbookmarks -- -j4
#cmake3 --build . --config RelWithDebInfo --target ext_kimageformats -- -j4

#cmake3 --build . --config RelWithDebInfo --target ext_libgphoto2 -- -j4

#cmake3 --build . --config RelWithDebInfo --target ext_png
#cmake3 --build . --config RelWithDebInfo --target ext_libxml2
#cmake3 --build . --config RelWithDebInfo --target ext_libxslt
