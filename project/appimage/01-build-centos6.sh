#!/bin/bash

# Script to build a CentOS 6 installation to compile an AppImage bundle of digiKam.
# This script must be run as sudo
#
# Copyright (c) 2015-2016, Gilles Caulier, <caulier dot gilles at gmail dot com>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.
#

# Halt on errors
set -e

#################################################################################################
# Manage script traces to log file

mkdir -p ./logs
exec > >(tee ./logs/build-linux.full.log) 2>&1

#################################################################################################

echo "01-build-linux.sh : build a CentOS 6 installation to compile an AppImage of digiKam."
echo "------------------------------------------------------------------------------------"

#################################################################################################
# Pre-processing checks

. ./config.sh
. ./common.sh
StartScript
ChecksCPUCores
CentOS6Adjustments
ORIG_WD="`pwd`"

#################################################################################################

echo -e "---------- Update Linux CentOS 6\n"

yum -y install epel-release

# we need to be up to date in order to install the xcb-keysyms dependency
yum -y update

#################################################################################################

echo -e "---------- Install New Development Packages\n"

# Packages for base dependencies and Qt5.
yum -y install wget \
               tar \
               bzip2 \
               gettext \
               git \
               subversion \
               libtool \
               which \
               fuse \
               automake \
               mesa-libEGL \
               cmake3 \
               gcc-c++ \
               patch \
               libxcb \
               xcb-util \
               xkeyboard-config \
               gperf \
               ruby \
               bison \
               flex \
               zlib-devel \
               expat-devel \
               fuse-devel \
               libjpeg-devel \
               libpng-devel \
               libtool-ltdl-devel \
               glib2-devel \
               glibc-headers \
               mysql-devel \
               openssl-devel \
               cppunit-devel \
               libstdc++-devel \
               freetype-devel \
               fontconfig-devel \
               libxml2-devel \
               libstdc++-devel \
               libXrender-devel \
               xcb-util-keysyms-devel \
               libXi-devel \
               mesa-libGL-devel \
               mesa-libGLU-devel \
               libxcb-devel \
               xcb-util-devel \
               glibc-devel \
               libudev-devel \
               libicu-devel \
               libtiff-devel \
               libgphoto2-devel \
               sane-backends-devel \
               jasper-devel \
               sqlite-devel \
               libusb-devel \
               libexif-devel \
               libical-devel \
               libxslt-devel \
               xz-devel \
               lz4-devel \
               inotify-tools-devel \
               openssl-devel 

#################################################################################################

echo -e "---------- Install New Compiler Tools Set\n"

# Newer compiler than what comes with CentOS 6
yum -y install centos-release-scl-rh
yum -y install devtoolset-4-gcc devtoolset-4-gcc-c++
. /opt/rh/devtoolset-4/enable

#################################################################################################

echo -e "---------- Clean-up Old Packages\n"

# Remove system based devel package to prevent conflict with new one.
yum -y erase qt-devel boost-devel

#################################################################################################

echo -e "---------- Prepare CentOS to Compile Nex Dependencies\n"

# Workaround for: On CentOS 6, .pc files in /usr/lib/pkgconfig are not recognized
# However, this is where .pc files get installed when bulding libraries... (FIXME)
# I found this by comparing the output of librevenge's "make install" command
# between Ubuntu and CentOS 6
ln -sf /usr/share/pkgconfig /usr/lib/pkgconfig

# Make sure we build from the /, parts of this script depends on that. We also need to run as root...
cd /

# Create the build dir for the 3rdparty deps
if [ ! -d /b ] ; then
    mkdir /b
fi
if [ ! -d /d ] ; then
    mkdir /d
fi

#################################################################################################

echo -e "---------- Install AppImage SDKs V1\n"

# Build standard AppImageKit

if [ ! -d /AppImageKit ] ; then
    git clone  --depth 1 https://github.com/probonopd/AppImageKit.git /AppImageKit
fi

cd /AppImageKit/
git reset --hard HEAD
git pull
./build.sh

#echo -e "---------- Install AppImage SDKs V2\n"

# Build new AppImageKit V2

#if [ ! -d /AppImageKitV2 ] ; then
#    git clone --recursive https://github.com/probonopd/appimagetool.git /AppImageKitV2
#fi

#cd /AppImageKitV2/
#./install-build-deps.sh
#./build.sh

# Get the ID of the last successful build on Travis CI
#ID=$(wget -q https://api.travis-ci.org/repos/probonopd/appimagetool/builds -O - | head -n 1 | sed -e 's|}|\n|g' | grep '"result":0' | head -n 1 | sed -e 's|,|\n|g' | grep '"id"' | cut -d ":" -f 2)

# Get the transfer.sh URL from the logfile of the last successful build on Travis CI
#URL=$(wget -q "https://s3.amazonaws.com/archive.travis-ci.org/jobs/$((ID+1))/log.txt" -O - | grep "https://transfer.sh/.*/appimagetool" | tail -n 1 | sed -e 's|\r||g')

#wget "$URL"

#################################################################################################

cd /b

rm -rf /b/* || true

cmake3 $ORIG_WD/3rdparty \
       -DCMAKE_INSTALL_PREFIX:PATH=/usr \
       -DINSTALL_ROOT=/usr \
       -DEXTERNALS_DOWNLOAD_DIR=/d


# Low level libraries and Qt5 dependencies
# NOTE: The order to compile each component here is very important.

cmake3 --build . --config RelWithDebInfo --target ext_exiv2               -- -j$CPU_CORES
cmake3 --build . --config RelWithDebInfo --target ext_lcms2               -- -j$CPU_CORES
cmake3 --build . --config RelWithDebInfo --target ext_boost               -- -j$CPU_CORES
cmake3 --build . --config RelWithDebInfo --target ext_eigen3              -- -j$CPU_CORES
cmake3 --build . --config RelWithDebInfo --target ext_opencv              -- -j$CPU_CORES
cmake3 --build . --config RelWithDebInfo --target ext_lensfun             -- -j$CPU_CORES
cmake3 --build . --config RelWithDebInfo --target ext_qt                  -- -j$CPU_CORES
cmake3 --build . --config RelWithDebInfo --target ext_qtwebkit            -- -j$CPU_CORES

#################################################################################################

TerminateScript
