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

#################################################################################################
# Pre-processing checks

. ../common/common.sh
StartScript
CommonSetup
ChecksRunAsRoot
ChecksXCodeCLI
ChecksCPUCores
OsxCodeName

#################################################################################################

# digiKam tarball information
LR_URL="http://www.libraw.org/data"
LR_BUILDTEMP=~/lrtemp
LR_VERSION=0.16.2

# digiKam tarball information
DK_URL="http://download.kde.org/stable/digikam/"
DK_BUILDTEMP=~/dktemp

# Pathes rules
ORIG_PATH="$PATH"
ORIG_WD="`pwd`"

export PATH=$INSTALL_PREFIX/bin:/$INSTALL_PREFIX/sbin:$ORIG_PATH

#################################################################################################
# Build Libraw in temporary directory and installation

if [ -d "$LR_BUILDTEMP" ] ; then
   echo "---------- Removing existing $LR_BUILDTEMP"
   rm -rf "$LR_BUILDTEMP"
fi

echo "---------- Creating $LR_BUILDTEMP"
mkdir "$LR_BUILDTEMP"

if [ $? -ne 0 ] ; then
    echo "---------- Cannot create $LR_BUILDTEMP directory."
    echo "---------- Aborting..."
    exit;
fi

cd "$LR_BUILDTEMP"
echo -e "\n\n"

echo "---------- Downloading Libraw $LR_VERSION"

curl -L -o "LibRaw-$LR_VERSION.tar.gz" "$LR_URL/LibRaw-$LR_VERSION.tar.gz"
curl -L -o "LibRaw-demosaic-pack-GPL2-$LR_VERSION.tar.gz" "$LR_URL/LibRaw-demosaic-pack-GPL2-$LR_VERSION.tar.gz"
curl -L -o "LibRaw-demosaic-pack-GPL3-$LR_VERSION.tar.gz" "$LR_URL/LibRaw-demosaic-pack-GPL3-$LR_VERSION.tar.gz"

tar zxvf LibRaw-$LR_VERSION.tar.gz
tar zxvf LibRaw-demosaic-pack-GPL2-$LR_VERSION.tar.gz
tar zxvf LibRaw-demosaic-pack-GPL3-$LR_VERSION.tar.gz

cd LibRaw-$LR_VERSION
echo -e "\n\n"

echo "---------- Configuring LibRaw"

./configure \
    --prefix=$INSTALL_PREFIX \
    --enable-openmp \
    --enable-lcms \
    --disable-examples \
    --enable-demosaic-pack-gpl2 \
    --enable-demosaic-pack-gpl3

echo -e "\n\n"

echo "---------- Building LibRaw"
make -j$CPU_CORES
echo -e "\n\n"

echo "---------- Installing LibRaw"
echo -e "\n\n"
make install && cd "$ORIG_WD" && rm -rf "$LR_BUILDTEMP"

#################################################################################################
# Build digiKam in temporary directory and installation

if [ -d "$DK_BUILDTEMP" ] ; then
   echo "---------- Removing existing $DK_BUILDTEMP"
   rm -rf "$DK_BUILDTEMP"
fi

echo "---------- Creating $DK_BUILDTEMP"
mkdir "$DK_BUILDTEMP"

if [ $? -ne 0 ] ; then
    echo "---------- Cannot create $DK_BUILDTEMP directory."
    echo "---------- Aborting..."
    exit;
fi

cd "$DK_BUILDTEMP"
echo -e "\n\n"

echo "---------- Downloading digiKam $DK_VERSION"

curl -L -o "digikam-$DK_VERSION.tar.bz2" "$DK_URL/digikam-$DK_VERSION.tar.bz2"

tar jxvf digikam-$DK_VERSION.tar.bz2

cp -f $ORIG_WD/../../../bootstrap.macports $DK_BUILDTEMP/digikam-$DK_VERSION
cd digikam-$DK_VERSION
echo -e "\n\n"

if [[ $MAJOR_OSX_VERSION -lt 9 ]]; then
    EXTRA_CXX_FLAGS="-mmacosx-version-min=10.7 -stdlib=libc++"
else
    EXTRA_CXX_FLAGS=""
fi

echo "---------- Configure digiKam with CXX extra flags : $EXTRA_CXX_FLAGS"

./bootstrap.macports "$INSTALL_PREFIX" "debugfull" "x86_64" "$EXTRA_CXX_FLAGS"

echo -e "\n\n"

echo "---------- Building digiKam"
cd build
make -j$CPU_CORES
echo -e "\n\n"

echo "---------- Installing digiKam"
echo -e "\n\n"
make install/fast && cd "$ORIG_WD" && rm -rf "$DK_BUILDTEMP"

#################################################################################################

export PATH=$ORIG_PATH

TerminateScript
