#!/bin/bash

# Copyright (c) 2013-2016, Gilles Caulier, <caulier dot gilles at gmail dot com>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.

########################################################################

# MXE configuration

#------------
# IMPORTANT: Target Windows architecture to build installer. Possible values: 32 or 64 bits.
MXE_ARCHBITS=64
#------------

if [[ $MXE_ARCHBITS == 32 ]]; then
    # Windows 32 bits shared
    MXE_BUILD_TARGETS="i686-w64-mingw32.shared"
    MXE_BUILDROOT="`pwd`/build.win32"
elif [[ $MXE_ARCHBITS == 64 ]]; then
    # Windows 64 bits shared
    MXE_BUILD_TARGETS="x86_64-w64-mingw32.shared"
    MXE_BUILDROOT="`pwd`/build.win64"
else
    echo "Unsupported or wrong target Windows architecture: $MXE_ARCHBITS bits."
    exit -1
fi

echo "Target Windows architecture: $MXE_ARCHBITS bits."

MXE_GIT_URL="https://github.com/mxe/mxe.git"
MXE_INSTALL_PREFIX=${MXE_BUILDROOT}/usr/${MXE_BUILD_TARGETS}/
MXE_TOOLCHAIN=${MXE_INSTALL_PREFIX}/share/cmake/mxe-conf.cmake

#-------------------------------------------------------------------------------------------

# KF5 extra libraries tarball information
KD_URL="http://download.kde.org/stable/frameworks/"
KD_BUILDTEMP=~/kf5libtemp
KD_VERSION=5.28

# KF5 extra applications tarball information
KA_URL="http://download.kde.org/stable/applications/"
KA_BUILDTEMP=~/kf5apptemp
KA_VERSION=16.04.3

# digiKam tarball information.
DK_URL="http://download.kde.org/stable/digikam"
# Location to build source code.
DK_BUILDTEMP=~/dktemp
# digiKam tarball information
DK_URL="http://download.kde.org/stable/digikam"
DK_BUILDTEMP=~/dktemp
# digiKam tag version from git. Official tarball do not include extra shared libraries.
# The list of tags can be listed with this url: https://quickgit.kde.org/?p=digikam.git&a=tags
# If you want to package current implemntation from git, use "master" as tag.
#DK_VERSION=v5.2.0
DK_VERSION=master
# Installer sub version to differentiates newer updates of the installer itself, even if the underlying application hasn’t changed.
DK_EPOCH="-01"

#-------------------------------------------------------------------------------------------

# Absolute path where are downloaded all tarballs to compile.
DOWNLOAD_DIR="`pwd`/temp/d"

# Absolute path where are compiled all tarballs
BUILDING_DIR="`pwd`/temp/b"
