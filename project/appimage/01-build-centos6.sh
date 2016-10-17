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
               libxslt-devel 

#################################################################################################

echo -e "---------- Install New Compiler Tools Set\n"

# Newer compiler than what comes with CentOS 6
yum -y install centos-release-scl-rh
yum -y install devtoolset-4-gcc devtoolset-4-gcc-c++
. /opt/rh/devtoolset-4/enable

#################################################################################################

echo -e "---------- Clean-up Old Packages\n"

# remove system based devel package to prevent conflict with new one.
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

echo -e "---------- Install AppImage SDK\n"

# Build AppImageKit
if [ ! -d AppImageKit ] ; then
    git clone  --depth 1 https://github.com/probonopd/AppImageKit.git /AppImageKit
fi

cd /AppImageKit/
git reset --hard HEAD
git pull
./build.sh
cd /

#################################################################################################

TerminateScript
