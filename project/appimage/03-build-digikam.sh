#! /bin/bash

# Script to build digiKam under Linux
# This script must be run as sudo
#
# Copyright (c) 2015-2016, Gilles Caulier, <caulier dot gilles at gmail dot com>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.
#

# Halt on error
set -e

#################################################################################################
# Manage script traces to log file

mkdir -p ./logs
exec > >(tee ./logs/build-digikam.full.log) 2>&1

#################################################################################################

echo "03-build-digikam.sh : build digiKam using CentOs 6."
echo "---------------------------------------------------"

#################################################################################################
# Pre-processing checks

. ./config.sh
. ./common.sh
StartScript
ChecksCPUCores
ChecksRunAsRoot
CentOS6Adjustments
. /opt/rh/devtoolset-4/enable
export CMAKE_BINARY=cmake3

#################################################################################################

# Pathes rules
ORIG_PATH="$PATH"
ORIG_WD="`pwd`"

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

git clone git://anongit.kde.org/digikam-software-compilation.git digikam-$DK_VERSION
cd digikam-$DK_VERSION
export GITSLAVE=".gitslave.devel"
./download-repos

if [ $? -ne 0 ] ; then
    echo "---------- Cannot clone repositories."
    echo "---------- Aborting..."
    exit;
fi

cd ./core 
git checkout $DK_VERSION
cd ../extra/kipi-plugins
git checkout $DK_VERSION
cd ../..

echo -e "\n\n"
echo "---------- Configure digiKam $DK_VERSION"

rm -rf build
mkdir build

sed -e "s/DIGIKAMSC_CHECKOUT_PO=OFF/DIGIKAMSC_CHECKOUT_PO=ON/g"                 ./bootstrap.linux > ./tmp.linux ; mv -f ./tmp.linux ./bootstrap.linux
sed -e "s/DIGIKAMSC_COMPILE_PO=OFF/DIGIKAMSC_COMPILE_PO=ON/g"                   ./bootstrap.linux > ./tmp.linux ; mv -f ./tmp.linux ./bootstrap.linux
sed -e "s/DBUILD_TESTING=ON/DBUILD_TESTING=OFF/g"                               ./bootstrap.linux > ./tmp.linux ; mv -f ./tmp.linux ./bootstrap.linux
sed -e "s/DENABLE_OPENCV3=OFF/DENABLE_OPENCV3=ON/g"                             ./bootstrap.linux > ./tmp.linux ; mv -f ./tmp.linux ./bootstrap.linux
sed -e "s/DENABLE_MEDIAPLAYER=ON/DENABLE_MEDIAPLAYER=OFF/g"                     ./bootstrap.linux > ./tmp.linux ; mv -f ./tmp.linux ./bootstrap.linux
sed -e "s/DENABLE_KFILEMETADATASUPPORT=ON/DENABLE_KFILEMETADATASUPPORT=OFF/g"   ./bootstrap.linux > ./tmp.linux ; mv -f ./tmp.linux ./bootstrap.linux
sed -e "s/DENABLE_AKONADICONTACTSUPPORT=ON/DENABLE_AKONADICONTACTSUPPORT=OFF/g" ./bootstrap.linux > ./tmp.linux ; mv -f ./tmp.linux ./bootstrap.linux
sed -e "s/DENABLE_MEDIAPLAYER=ON/DENABLE_MEDIAPLAYER=OFF/g"                     ./bootstrap.linux > ./tmp.linux ; mv -f ./tmp.linux ./bootstrap.linux

chmod +x ./bootstrap.linux

./bootstrap.linux

if [ $? -ne 0 ]; then
    echo "---------- Cannot configure digiKam $DK_VERSION."
    echo "---------- Aborting..."
    exit;
fi

if [ -d ./extra/libkvkontakte/src ]; then
    ln -sf src ./extra/libkvkontakte/Vkontakte
fi

if [ -d ./extra/libmediawiki/src ]; then
    ln -sf src ./extra/libmediawiki/MediaWiki
fi

cat ../build/core/app/utils/digikam_version.h | grep "digikam_version\[\]" | awk '{print $6}' | tr -d '";' > $ORIG_WD/data/RELEASEID.txt

echo -e "\n\n"
echo "---------- Building digiKam $DK_VERSION"

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
