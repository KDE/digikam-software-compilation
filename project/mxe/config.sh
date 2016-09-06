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
MXE_PACKAGES="gcc \
              gdb \
              cmake \
              freeglut \
              libxml2 \
              libxslt \
              libpng \
              jpeg \
              tiff \
              boost \
              gettext \
              jasper \
              expat \
              lcms \
              lensfun \
              liblqr-1 \
              eigen \
              zlib \
              exiv2 \
              opencv \
              qt5 \
             "

#-------------------------------------------------------------------------------------------

# KF5 extra libraries tarball information
KD_URL="http://download.kde.org/stable/frameworks/"
KD_BUILDTEMP=~/kf5libtemp
KD_VERSION=5.25

# KF5 extra applications tarball information
KA_URL="http://download.kde.org/stable/applications/"
KA_BUILDTEMP=~/kf5apptemp
KA_VERSION=16.08.0

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
#DK_VERSION=v5.1.0
DK_VERSION=master
# Installer sub version to differentiates newer updates of the installer itself, even if the underlying application hasn’t changed.
DK_EPOCH="-01"

# Hugin tarball information
HU_URL="http://sourceforge.net/projects/hugin/files/hugin/"
HU_BUILDTEMP=~/hutemp
HU_VERSION=2015.0

# MariaDB tarball information
MD_URL="http://de-rien.fr/mariadb"
MD_BUILDTEMP=~/mdtemp
MD_VERSION=10.2.0

# Libraries to build outside Macports at the same time than digiKam through 03-build-digikam.sh
ENABLE_HUGIN=0
ENABLE_MARIADB=0
