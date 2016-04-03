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

exec > >(tee build-digikam.full.log) 2>&1

#################################################################################################

echo "03-build-digikam.sh : build digiKam using MacPorts."
echo "---------------------------------------------------"

#################################################################################################
# Pre-processing checks

. ./configbundlepkg.sh
. ../common/common.sh
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

# Temporally solution to be able to use Qt4::qmake at the smae time than Qt5:qmake
#export PATH=$INSTALL_PREFIX/libexec/qt4/bin:$PATH

if [[ $MAJOR_OSX_VERSION -lt 9 ]]; then
    EXTRA_CXX_FLAGS="-mmacosx-version-min=10.7 -stdlib=libc++"
else
    EXTRA_CXX_FLAGS=""
fi

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

cp -f $ORIG_WD/../../../bootstrap.macports $DK_BUILDTEMP/digikam-$DK_VERSION
if [ $? -ne 0 ]; then
    echo "---------- Cannot copy bootstrap configuration file to temp dir."
    echo "---------- Aborting..."
    exit;
fi

echo -e "\n\n"
echo "---------- Configure digiKam with CXX extra flags : $EXTRA_CXX_FLAGS"

export VERBOSE=ON
./bootstrap.macports "$INSTALL_PREFIX" "debugfull" "x86_64" "$EXTRA_CXX_FLAGS"
if [ $? -ne 0 ]; then
    echo "---------- Cannot configure digiKam $DK_VERSION."
    echo "---------- Aborting..."
    exit;
fi

echo -e "\n\n"
echo "---------- Building digiKam"

cd build
#make -j$CPU_CORES
make
if [ $? -ne 0 ]; then
    echo "---------- Cannot compile digiKam $DK_VERSION."
    echo "---------- Aborting..."
    exit;
fi

echo -e "\n\n"
echo "---------- Installing digiKam"
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

