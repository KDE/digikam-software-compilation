#!/bin/sh

# Copyright (c) 2013-2015, Gilles Caulier, <caulier dot gilles at gmail dot com>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.

########################################################################

# Set common variables for bundle PKG

# Directory where MacPorts will be built, and where it will be installed by packaging script
INSTALL_PREFIX="/opt/digikam"

# Macports tarball information
MP_URL="https://distfiles.macports.org/MacPorts/"
MP_BUILDTEMP=~/mptemp
# Uncomment this line to force a specific version of Macports to use, else lastest will be used.
#MP_VERSION="2.3.3"

# Exiv2 tarball information
EX_URL="http://www.exiv2.org"
EX_BUILDTEMP=~/extemp
#EX_VERSION=svn
EX_VERSION=0.25

# Lensfun tarball information
LF_URL="http://sourceforge.net/projects/lensfun/files/"
LF_BUILDTEMP=~/lftemp
LF_VERSION=0.3.1

# Libraw tarball information
LR_URL="http://www.libraw.org/data"
LR_BUILDTEMP=~/lrtemp
LR_VERSION=0.16.2

# OpenCV tarball information
OC_URL="http://sourceforge.net/projects/opencvlibrary/files/opencv-unix/"
OC_BUILDTEMP=~/octemp
OC_VERSION=2.4.11

# Hugin tarball information
HU_URL="http://sourceforge.net/projects/hugin/files/hugin/"
HU_BUILDTEMP=~/hutemp
HU_VERSION=2013.0

# digiKam tarball information
DK_URL="http://download.kde.org/stable/digikam"
DK_BUILDTEMP=~/dktemp
#DK_VERSION=git
DK_VERSION=4.12.0

# Libraries to build outside Macports at the same time than digiKam through 02-build-digikam.sh
# 0: use port file
# 1: use tarball
ENABLE_LIBRAW=1
ENABLE_EXIV2=1
ENABLE_LENSFUN=1
ENABLE_OPENCV=0
ENABLE_HUGIN=1
