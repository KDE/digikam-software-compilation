#!/bin/sh

# Copyright (c) 2013-2016, Gilles Caulier, <caulier dot gilles at gmail dot com>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.

########################################################################

# MXE configuration
MXE_GIT_URL="https://github.com/mxe/mxe.git"

# 32 bits static
#MXE_BUILD_TARGETS="i686-w64-mingw32.static"
# 64 bits static
#MXE_BUILD_TARGETS="x86_64-w64-mingw32.static"
# 32 bits shared
MXE_BUILD_TARGETS="i686-w64-mingw32.shared"
# 64 bits shared
#MXE_BUILD_TARGETS="x86_64-w64-mingw32.shared"

MXE_BUILDROOT="`pwd`/build"
MXE_INSTALL_PREFIX=${MXE_BUILDROOT}/usr/${MXE_BUILD_TARGETS}/
MXE_TOOLCHAIN=${MXE_INSTALL_PREFIX}/share/cmake/mxe-conf.cmake
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
              lensfun \
              liblqr-1 \
              boost \
              eigen \
              zlib \
              exiv2 \
              freeglut \
              opencv \
              dbus \
              gst-plugins-base \
              gst-plugins-bad \
              gst-plugins-good \
              gst-plugins-ugly \
              qt5 \
             "

# Hugin tarball information
HU_URL="http://sourceforge.net/projects/hugin/files/hugin/"
HU_BUILDTEMP=~/hutemp
HU_VERSION=2013.0

# KF5 extra libraries tarball information
KD_URL="http://download.kde.org/stable/frameworks/"
KD_BUILDTEMP=~/kf5libtemp
KD_VERSION=5.22

# KF5 extra applications tarball information
KA_URL="http://download.kde.org/stable/applications/"
KA_BUILDTEMP=~/kf5apptemp
KA_VERSION=16.04.1

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
