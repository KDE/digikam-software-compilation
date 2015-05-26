#! /bin/bash

# Script to build digiKam using MacPorts
# This script must be run as sudo
#
# Copyright (c) 2015, Shanti, <listaccount at revenant dot org>
# Copyright (c) 2015, Gilles Caulier, <caulier dot gilles at gmail dot com>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.
#

echo "02-build-digikam.sh : build digiKam using MacPorts."
echo "---------------------------------------------------"

begin=$(date +"%s")

# Pre-processing checks
. ../common/common.sh
CommonSetup
ChecksRunAsRoot
ChecksXCodeCLI

#################################################################################################"

# digiKam tarball information
DK_URL="http://download.kde.org/stable/digikam/"
DK_BUILDTEMP=~/dktemp

# Pathes rules
ORIG_PATH="$PATH"
ORIG_WD="`pwd`"

#################################################################################################"
# Build digiKam in temporary directory and installation

export PATH=$INSTALL_PREFIX/bin:/$INSTALL_PREFIX/sbin:$ORIG_PATH

if [ -d "$DK_BUILDTEMP" ] ; then
   echo "---------- Removing existing $DK_BUILDTEMP"
   rm -rf "$DK_BUILDTEMP"
fi

echo "---------- Creating $DK_BUILDTEMP"
mkdir "$DK_BUILDTEMP"

cd "$DK_BUILDTEMP"
echo -e "\n\n"

echo "---------- Downloading digiKam $DK_VERSION"

curl -L -o "digikam-$DK_VERSION.tar.bz2" "$DK_URL/digikam-$DK_VERSION.tar.bz2"

tar jxvf digikam-$DK_VERSION.tar.bz2

cp -f $ORIG_WD/../../../bootstrap.macports $DK_BUILDTEMP/digikam-$DK_VERSION
cd digikam-$DK_VERSION
echo -e "\n\n"

echo "---------- Configuring digiKam"

./bootstrap.macports $INSTALL_PREFIX

echo -e "\n\n"

echo "---------- Building digiKam"
cd build
make -j8
echo -e "\n\n"

echo "---------- Installing digiKam"
echo -e "\n\n"
make install/fast && cd "$ORIG_WD" && rm -rf "$DK_BUILDTEMP"

#################################################################################################"

export PATH=$ORIG_PATH

termin=$(date +"%s")
difftimelps=$(($termin-$begin))
echo "$(($difftimelps / 60)) minutes and $(($difftimelps % 60)) seconds elapsed for Script Execution."
