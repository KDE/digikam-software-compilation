#! /bin/bash

# Script to build extra libraries using MacPorts env.
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
exec > >(tee ./logs/build-extralibs.full.log) 2>&1

#################################################################################################

echo "02-build-extralibs.sh : build extra libraries using MacPorts."
echo "-------------------------------------------------------------"

#################################################################################################
# Pre-processing checks

. ./configbundlepkg.sh
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

if [[ $MAJOR_OSX_VERSION -lt 9 ]]; then
    EXTRA_CXX_FLAGS="-mmacosx-version-min=10.7 -stdlib=libc++"
else
    EXTRA_CXX_FLAGS=""
fi

#################################################################################################
# Build KF5 frameworks in a temporary directory and installation
# See KF5DEPENDENCIES details about the big puzzle

InstallKDEExtraLib "extra-cmake-modules"
InstallKDEExtraLib "kconfig"
InstallKDEExtraLib "breeze-icons"
InstallKDEExtraLib "kcoreaddons"
InstallKDEExtraLib "kwindowsystem"
InstallKDEExtraLib "solid"
InstallKDEExtraLib "threadweaver"
InstallKDEExtraLib "karchive"
InstallKDEExtraLib "kdbusaddons"
InstallKDEExtraLib "ki18n"
InstallKDEExtraLib "kcrash"
InstallKDEExtraLib "kcodecs"
InstallKDEExtraLib "kauth"
InstallKDEExtraLib "kguiaddons"
InstallKDEExtraLib "kwidgetsaddons"
InstallKDEExtraLib "kitemviews"
InstallKDEExtraLib "kcompletion"
InstallKDEExtraLib "kconfigwidgets"
InstallKDEExtraLib "kiconthemes"
InstallKDEExtraLib "kservice"
InstallKDEExtraLib "kglobalaccel"
InstallKDEExtraLib "kxmlgui"
InstallKDEExtraLib "kbookmarks"
InstallKDEExtraLib "kjobwidgets"
InstallKDEExtraLib "kio"

#################################################################################################
# Build Hugin in temporary directory and installation

if [[ $ENABLE_HUGIN == 1 ]]; then

    if [ -d "$HU_BUILDTEMP" ] ; then
    echo "---------- Removing existing $HU_BUILDTEMP"
    rm -rf "$HU_BUILDTEMP"
    fi

    echo "---------- Creating $HU_BUILDTEMP"
    mkdir "$HU_BUILDTEMP"

    if [ $? -ne 0 ] ; then
        echo "---------- Cannot create $HU_BUILDTEMP directory."
        echo "---------- Aborting..."
        exit;
    fi

    cd "$HU_BUILDTEMP"
    echo -e "\n\n"

    echo "---------- Downloading Hugin $HU_VERSION"

    curl -L -o "hugin-$HU_VERSION.tar.bz2" "$HU_URL/hugin-$HU_VERSION/hugin-$HU_VERSION.0.tar.bz2"

    tar jxvf hugin-$HU_VERSION.tar.bz2
    cd hugin-$HU_VERSION.0

    echo -e "\n\n"

    echo "---------- Configuring Hugin"

    cmake \
        -G "Unix Makefiles" \
        -DCMAKE_BUILD_TYPE=debugfull \
        -DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX} \
        -DCMAKE_OSX_ARCHITECTURES=x86_64 \
        -DCMAKE_CXX_FLAGS="${CMAKE_CXX_FLAGS} ${EXTRA_CXX_FLAGS}" \
        -DCMAKE_COLOR_MAKEFILE=ON \
        -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON \
        -DCMAKE_INSTALL_NAME_DIR=${INSTALL_PREFIX}/lib \
        -DCMAKE_SYSTEM_PREFIX_PATH="${INSTALL_PREFIX};/usr" \
        -DCMAKE_MODULE_PATH="${INSTALL_PREFIX}/share/cmake/modules" \
        .

    echo -e "\n\n"

    echo "---------- Building Hugin"
    make -j$CPU_CORES
    echo -e "\n\n"

    echo "---------- Installing Hugin"
    echo -e "\n\n"
    make install && cd "$ORIG_WD" && rm -rf "$HU_BUILDTEMP"

fi

export PATH=$ORIG_PATH

TerminateScript
