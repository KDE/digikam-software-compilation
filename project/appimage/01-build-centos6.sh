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

yum -y install epel-release

# we need to be up to date in order to install the xcb-keysyms dependency
yum -y update

# base dependencies and Qt5.
yum -y install wget \
               tar \
               bzip2 \
               gettext \
               zlib-devel \
               expat-devel \
               git \
               libtool \
               which \
               fuse \
               fuse-devel \
               libjpeg-devel \
               libpng-devel \
               automake \
               libtool-ltdl-devel \
               glib2-devel \
               glibc-headers \
               mysql-devel \
               openssl-devel \
               mesa-libEGL \
               cppunit-devel \
               cmake3 \
               glibc-headers \
               libstdc++-devel \
               gcc-c++ \
               freetype-devel \
               fontconfig-devel \
               libxml2-devel \
               libstdc++-devel \
               libXrender-devel \
               patch \
               xcb-util-keysyms-devel \
               libXi-devel \
               mesa-libGL-devel \
               mesa-libGLU-devel \
               libxcb \
               libxcb-devel \
               xcb-util \
               xcb-util-devel \
               glibc-devel \
               xkeyboard-config \
               libudev-devel \
               libicu-devel \
               libtiff-devel \
               libgphoto2-devel \
               sane-backends-devel \
               gperf \
               ruby \
               jasper-devel \
               sqlite-devel \
               libusb-devel \
               libexif-devel \
               libical-devel \
               libxslt-devel \
               bison \
               flex \
               perl-URI \
               docbook-style-xsl

# Newer compiler than what comes with CentOS 6
yum -y install centos-release-scl-rh
yum -y install devtoolset-4-gcc devtoolset-4-gcc-c++
. /opt/rh/devtoolset-4/enable

# remove system based devel package to prevent conflict with new one.
yum -y erase qt-devel boost-devel

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

# Build AppImageKit
if [ ! -d AppImageKit ] ; then
    git clone  --depth 1 https://github.com/probonopd/AppImageKit.git /AppImageKit
fi

cd /AppImageKit/
git_pull_rebase_helper
./build.sh
cd /

#################################################################################################

TerminateScript
