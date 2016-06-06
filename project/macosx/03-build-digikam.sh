#! /bin/bash

# Script to build digiKam using MacPorts
# This script must be run as sudo
#
# Copyright (c) 2015-2016, Gilles Caulier, <caulier dot gilles at gmail dot com>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.
#

#################################################################################################
# Manage script traces to log file

mkdir -p ./logs
exec > >(tee ./logs/build-digikam.full.log) 2>&1

#################################################################################################

echo "03-build-digikam.sh : build digiKam using MacPorts."
echo "---------------------------------------------------"

#################################################################################################
# Pre-processing checks

. ./config.sh
. ./common.sh
StartScript
ChecksRunAsRoot
ChecksXCodeCLI
ChecksCPUCores
OsxCodeName

#################################################################################################

# Pathes rules
ORIG_PATH="$PATH"
ORIG_WD="`pwd`"

export PATH=$INSTALL_PREFIX/bin:/$INSTALL_PREFIX/sbin:$ORIG_PATH

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

if [[ "$DK_VERSION" == "git" ]] ; then
    git clone git@git.kde.org:digikam-software-compilation digikam-$DK_VERSION
    cd digikam-$DK_VERSION
    export GITSLAVE=".gitslave.devel"
    ./download-repos
else
    curl -L -o "digikam-$DK_VERSION.tar.bz2" "$DK_URL/digikam-$DK_VERSION.tar.bz2"
    tar jxvf digikam-$DK_VERSION.tar.bz2
    cd digikam-$DK_VERSION
fi

cp -f $ORIG_WD/../../bootstrap.macports $DK_BUILDTEMP/digikam-$DK_VERSION

echo -e "\n\n"
echo "---------- Configure digiKam $DK_VERSION"

sed -e "s/DIGIKAMSC_CHECKOUT_PO=OFF/DIGIKAMSC_CHECKOUT_PO=ON/g" ./bootstrap.macports > ./tmp.mxe ; mv -f ./tmp.mxe ./bootstrap.macports
sed -e "s/DIGIKAMSC_COMPILE_PO=OFF/DIGIKAMSC_COMPILE_PO=ON/g"   ./bootstrap.macports > ./tmp.mxe ; mv -f ./tmp.mxe ./bootstrap.macports
sed -e "s/DBUILD_TESTING=ON/DBUILD_TESTING=OFF/g"               ./bootstrap.macports > ./tmp.mxe ; mv -f ./tmp.mxe ./bootstrap.macports
chmod +x ./bootstrap.macports

./bootstrap.macports "$INSTALL_PREFIX" "debugfull" "x86_64" "-Wno-dev"

if [ $? -ne 0 ]; then
    echo "---------- Cannot configure digiKam $DK_VERSION."
    echo "---------- Aborting..."
    exit;
fi

cat ./build/core/app/utils/digikam_version.h | grep "digikam_version\[\]" | awk '{print $6}' | tr -d '";' > $ORIG_WD/data/RELEASEID.txt

echo -e "\n\n"
echo "---------- Building digiKam $DK_VERSION"

cd build
make -j$CPU_CORES

if [ $? -ne 0 ]; then
    echo "---------- Cannot compile digiKam $DK_VERSION."
    echo "---------- Aborting..."
    exit;
fi

echo -e "\n\n"
echo "---------- Installing digiKam $DK_VERSION"
echo -e "\n\n"

make install/fast && cd "$ORIG_WD" && rm -rf "$DK_BUILDTEMP"

if [ $? -ne 0 ]; then
    echo "---------- Cannot install digiKam $DK_VERSION."
    echo "---------- Aborting..."
    exit;
fi

#################################################################################################

export PATH=$ORIG_PATH

TerminateScript
