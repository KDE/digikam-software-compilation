#!/bin/sh

# Copyright (c) 2013-2016, Gilles Caulier, <caulier dot gilles at gmail dot com>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.

########################################################################

# MXE configuration
MXE_GIT_URL="https://github.com/mxe/mxe.git"
MXE_BUILD_TARGETS="x86_64-w64-mingw32.shared"
MXE_BUILDROOT="`pwd`/build"
MXE_TOOLCHAIN=${MXE_BUILDROOT}/usr/x86_64-w64-mingw32.shared/share/cmake/mxe-conf.cmake
MXE_INSTALL_PREFIX=${MXE_BUILDROOT}/usr/x86_64-w64-mingw32.shared/
MXE_PACKAGES="gcc \
              libxml2 \
              libxslt \
              cmake \
              libpng \
              jpeg \
              tiff \
              boost \
              gettext \
              jasper \
              expat \
              lcms \
              boost \
              eigen \
              zlib \
              exiv2 \
              freeglut \
              opencv \
              dbus \
              qt5 \
             "

# Hugin tarball information
HU_URL="http://sourceforge.net/projects/hugin/files/hugin/"
HU_BUILDTEMP=~/hutemp
HU_VERSION=2013.0

# KF5 extra libs tarball information
KD_URL="http://download.kde.org/stable/frameworks/"
KD_BUILDTEMP=~/kf5temp
KD_VERSION=5.21

# digiKam tarball information
DK_URL="http://download.kde.org/stable/digikam"
DK_BUILDTEMP=~/dktemp
DK_VERSION=git
#DK_VERSION=5.0.0

# Option to silent operations while configuring, compiling and installing extra libraries.
SILENT_OP=0

# Libraries to build outside Macports at the same time than digiKam through 02-build-digikam.sh
# 0: use port file
# 1: use tarball
ENABLE_HUGIN=0
