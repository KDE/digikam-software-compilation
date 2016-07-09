#!/bin/bash

# Copyright (c) 2013-2016, Gilles Caulier, <caulier dot gilles at gmail dot com>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.

########################################################################

# Minimum OSX target for backward binary compatibility
# This require to install older OSX SDKs with Xcode.
# See this url for details: https://github.com/phracker/MacOSX-SDKs
# Possible values:
# 10.11 : El Capitan   (tested)
# 10.10 : Yosemite     (tested)
# 10.9  : Mavericks    (tested)
# 10.8  : MountainLion (tested)
# 10.7  : Lion         (untested)
# 10.6  : SnowLeopard  (untested)
# Older values cannot be set as it do no support x86_64.
OSX_MIN_TARGET="10.8"

# Directory where not relocable bundle will be built, and where it will be installed by packaging script
INSTALL_PREFIX="/opt/digikam"

# Macports configuration
MP_URL="https://distfiles.macports.org/MacPorts/"
MP_BUILDTEMP=~/mptemp

# Uncomment this line to force a specific version of Macports to use, else lastest will be used.
#MP_VERSION="2.3.3"

MP_PACKAGES="qt5 \
             qt5-sqlite-plugin \
             qt5-mysql-plugin \
             qt5-qtscript \
             qt5-qtwebkit \
             cmake \
             opencv \
             libpng \
             jpeg \
             tiff \
             exiv2 \
             boost \
             gettext \
             libusb \
             libgphoto2 \
             jasper \
             lcms2 \
             eigen3 \
             expat \
             libxml2 \
             libxslt \
             lensfun \
             "

# KF5 extra libs tarball information
KD_URL="http://download.kde.org/stable/frameworks/"
KD_BUILDTEMP=~/kf5temp
KD_VERSION=5.23

# KF5 extra applications tarball information
KA_URL="http://download.kde.org/stable/applications/"
KA_BUILDTEMP=~/kf5apptemp
KA_VERSION=16.04.2

# digiKam tarball information
DK_URL="http://download.kde.org/stable/digikam"
DK_BUILDTEMP=~/dktemp
# digiKam tag version from git. Official tarball do not include extra shared libraries.
DK_VERSION=v5.0.0
# Installer sub version to differentiates newer updates of the installer itself, even if the underlying application hasn’t changed.
DK_EPOCH=""

# Hugin tarball information
HU_URL="http://sourceforge.net/projects/hugin/files/hugin/"
HU_BUILDTEMP=~/hutemp
HU_VERSION=2015.0

# Libraries to build outside Macports at the same time than digiKam through 03-build-digikam.sh
# 0: use port file
# 1: use tarball
ENABLE_HUGIN=0
