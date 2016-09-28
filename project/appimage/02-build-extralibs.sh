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

ORIG_WD="`pwd`"

# Make sure we build from the /, parts of this script depends on that. We also need to run as root...
cd  /

# start building the deps
cd /b

rm -rf /b/* || true

. /opt/rh/devtoolset-3/enable

cmake3 $ORIG_WD/3rdparty \
    -DCMAKE_INSTALL_PREFIX:PATH=/usr \
    -DINSTALL_ROOT=/usr \
    -DEXTERNALS_DOWNLOAD_DIR=/d


#cmake3 --build . --config RelWithDebInfo --target ext_expat
#cmake3 --build . --config RelWithDebInfo --target ext_gettext
#cmake3 --build . --config RelWithDebInfo --target ext_iconv
#cmake3 --build . --config RelWithDebInfo --target ext_zlib
#cmake3 --build . --config RelWithDebInfo --target ext_tiff
#cmake3 --build . --config RelWithDebInfo --target ext_jpeg
#cmake3 --build . --config RelWithDebInfo --target ext_boost
#cmake3 --build . --config RelWithDebInfo --target ext_eigen3
#cmake3 --build . --config RelWithDebInfo --target ext_exiv2
#cmake3 --build . --config RelWithDebInfo --target ext_lcms2
#cmake3 --build . --config RelWithDebInfo --target ext_libraw
#cmake3 --build . --config RelWithDebInfo --target ext_qt -- -j4

#cmake3 --build . --config RelWithDebInfo --target ext_extra_cmake_modules
#cmake3 --build . --config RelWithDebInfo --target ext_kconfig
#cmake3 --build . --config RelWithDebInfo --target ext_breeze_icons
#cmake3 --build . --config RelWithDebInfo --target ext_solid
#cmake3 --build . --config RelWithDebInfo --target ext_kcoreaddons
cmake3 --build . --config RelWithDebInfo --target ext_kwindowsystem -- -j4
cmake3 --build . --config RelWithDebInfo --target ext_solid
cmake3 --build . --config RelWithDebInfo --target ext_threadweaver
cmake3 --build . --config RelWithDebInfo --target ext_karchive
cmake3 --build . --config RelWithDebInfo --target ext_kdbusaddons
cmake3 --build . --config RelWithDebInfo --target ext_ki18n
cmake3 --build . --config RelWithDebInfo --target ext_kcrash
cmake3 --build . --config RelWithDebInfo --target ext_kcodecs
cmake3 --build . --config RelWithDebInfo --target ext_kauth
cmake3 --build . --config RelWithDebInfo --target ext_kguiaddons
cmake3 --build . --config RelWithDebInfo --target ext_kwidgetsaddons
cmake3 --build . --config RelWithDebInfo --target ext_kitemviews
cmake3 --build . --config RelWithDebInfo --target ext_kcompletion
cmake3 --build . --config RelWithDebInfo --target ext_kconfigwidgets
cmake3 --build . --config RelWithDebInfo --target ext_kiconthemes
cmake3 --build . --config RelWithDebInfo --target ext_kservice
cmake3 --build . --config RelWithDebInfo --target ext_kglobalaccel
cmake3 --build . --config RelWithDebInfo --target ext_kxmlgui
cmake3 --build . --config RelWithDebInfo --target ext_kbookmarks
cmake3 --build . --config RelWithDebInfo --target ext_kimageformats




#cmake3 --build . --config RelWithDebInfo --target ext_png
#cmake3 --build . --config RelWithDebInfo --target ext_libxml2
#cmake3 --build . --config RelWithDebInfo --target ext_libxslt
