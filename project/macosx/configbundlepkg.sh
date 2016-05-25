#!/bin/sh

# Copyright (c) 2013-2016, Gilles Caulier, <caulier dot gilles at gmail dot com>
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

# KF5 extra libs tarball information
KD_URL="http://download.kde.org/stable/frameworks/"
KD_BUILDTEMP=~/kf5temp
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

# Hugin tarball information
HU_URL="http://sourceforge.net/projects/hugin/files/hugin/"
HU_BUILDTEMP=~/hutemp
HU_VERSION=2013.0

# Option to silent operations while configuring, compiling and installing extra libraries.
SILENT_OP=0

# Libraries to build outside Macports at the same time than digiKam through 03-build-digikam.sh
# 0: use port file
# 1: use tarball
ENABLE_LENSFUN=1
ENABLE_HUGIN=0
