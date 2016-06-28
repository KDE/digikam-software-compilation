#!/bin/bash

# Copyright (c) 2013-2016, Gilles Caulier, <caulier dot gilles at gmail dot com>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.

########################################################################

# Minimum OSX target for backward binary compatibility
OSX_MIN_TARGET="10.9"

# Directory where MacPorts will be built, and where it will be installed by packaging script
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
             libpgf \
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

# TODO check if these packages below still necessary
#             liblqr
#             hugin
#             enblend
#             sane-backends

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
DK_VERSION=git
#DK_VERSION=5.0.0

# Hugin tarball information
HU_URL="http://sourceforge.net/projects/hugin/files/hugin/"
HU_BUILDTEMP=~/hutemp
HU_VERSION=2015.0

# Libraries to build outside Macports at the same time than digiKam through 03-build-digikam.sh
# 0: use port file
# 1: use tarball
ENABLE_HUGIN=0
