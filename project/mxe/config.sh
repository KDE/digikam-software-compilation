#!/bin/bash

# Copyright (c) 2013-2016, Gilles Caulier, <caulier dot gilles at gmail dot com>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.

########################################################################

# MXE configuration

#------------
# IMPORTANT: Target Windows architecture to build target installer. Just comment unwanted one.
# Windows 32 bits shared
MXE_BUILD_TARGETS="i686-w64-mingw32.shared"
# Windows 64 bits shared
#MXE_BUILD_TARGETS="x86_64-w64-mingw32.shared"
#------------

MXE_GIT_URL="https://github.com/mxe/mxe.git"
MXE_BUILDROOT="`pwd`/build"
MXE_INSTALL_PREFIX=${MXE_BUILDROOT}/usr/${MXE_BUILD_TARGETS}/
MXE_TOOLCHAIN=${MXE_INSTALL_PREFIX}/share/cmake/mxe-conf.cmake
MXE_PACKAGES="gcc \
              gdb \
              cmake \
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
              freeglut \
              opencv \
              dbus \
              qt5 \
             "

#For hugin 2015.0. WxWidget do not compile as shared.
#              wxwidgets
#              vigra
#              libpano13

#-------------------------------------------------------------------------------------------

# KF5 extra libraries tarball information
KD_URL="http://download.kde.org/stable/frameworks/"
KD_BUILDTEMP=~/kf5libtemp
KD_VERSION=5.22

# KF5 extra applications tarball information
KA_URL="http://download.kde.org/stable/applications/"
KA_BUILDTEMP=~/kf5apptemp
KA_VERSION=16.04.1

# Hugin tarball information
HU_URL="http://sourceforge.net/projects/hugin/files/hugin/"
HU_BUILDTEMP=~/hutemp
HU_VERSION=2015.0

# MariaDB tarball information
MD_URL="http://de-rien.fr/mariadb"
MD_BUILDTEMP=~/mdtemp
MD_VERSION=10.2.0

# digiKam tarball information
DK_URL="http://download.kde.org/stable/digikam"
DK_BUILDTEMP=~/dktemp
DK_VERSION=git
#DK_VERSION=5.0.0

# Libraries to build outside Macports at the same time than digiKam through 02-build-digikam.sh
ENABLE_HUGIN=0
ENABLE_MARIADB=0
