#!/bin/sh

# Copyright (c) 2013-2016, Gilles Caulier, <caulier dot gilles at gmail dot com>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.

########################################################################
# Check if run as root
ChecksRunAsRoot()
{

if [[ $EUID -ne 0 ]]; then
    echo "This script should be run as root using sudo command."
    exit 1
else
    echo "Check run as root passed..."
fi

}

########################################################################
# Check CPU core available (Linux or OSX)
ChecksCPUCores()
{

CPU_CORES=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || sysctl -n hw.ncpu)

echo "CPU Cores detected : $CPU_CORES"

}

########################################################################
# Performs All Checks
CommonChecks()
{

ChecksRunAsRoot
ChecksXCodeCLI
ChecksMacports

}

########################################################################
# For time execution measurement ; startup
StartScript()
{

BEGIN_SCRIPT=$(date +"%s")

}

########################################################################
# For time execution measurement : shutdown
TerminateScript()
{

TERMIN_SCRIPT=$(date +"%s")
difftimelps=$(($TERMIN_SCRIPT-$BEGIN_SCRIPT))
echo "Elaspsed time for script execution : $(($difftimelps / 3600 )) hours $((($difftimelps % 3600) / 60)) minutes $(($difftimelps % 60)) seconds"

}

########################################################################
# Install extra KF5 frameworks library
# arguments : library name, additional cmake flags, download url, version 
#
InstallKDEExtraLib()
{

LIB_NAME=$1

if [ -d "$KD_BUILDTEMP" ] ; then
   echo "---------- Removing existing $KD_BUILDTEMP"
   rm -rf "$KD_BUILDTEMP"
fi

echo "---------- Creating $KD_BUILDTEMP"
mkdir "$KD_BUILDTEMP"

if [ $? -ne 0 ]; then
    echo "---------- Cannot create $KD_BUILDTEMP directory."
    echo "---------- Aborting..."
    exit;
fi

cd "$KD_BUILDTEMP"
echo -e "\n\n"

echo "---------- Downloading $LIB_NAME $KD_VERSION"
echo "---------- URL: $KD_URL/$KD_VERSION/$LIB_NAME-$KD_VERSION.tar.xz"

curl -L -o "$LIB_NAME-$KD_VERSION.tar.xz" "$KD_URL/$KD_VERSION/$LIB_NAME-$KD_VERSION.0.tar.xz"

if [ $? -ne 0 ]; then
    echo "---------- Cannot download $LIB_NAME-$KD_VERSION.tar.xz archive."
    echo "---------- Aborting..."
    exit;
fi

tar -xJf $LIB_NAME-$KD_VERSION.tar.xz
if [ $? -ne 0 ]; then
    echo "---------- Cannot extract $LIB_NAME-$KD_VERSION.tar.xz archive."
    echo "---------- Aborting..."
    exit;
fi

cd $LIB_NAME-$KD_VERSION.0
pwd

echo -e "\n\n"
echo "---------- Configure $LIB_NAME with CXX extra flags : $EXTRA_CXX_FLAGS"

x86_64-w64-mingw32.shared-cmake -G "Unix Makefiles" . \
                                -DBUILD_TESTING=OFF \
                                -DMXE_TOOLCHAIN=${MXE_TOOLCHAIN} \
                                -DCMAKE_BUILD_TYPE=debug \
                                -DCMAKE_COLOR_MAKEFILE=ON \
                                -DCMAKE_INSTALL_PREFIX=${MXE_INSTALL_PREFIX} \
                                -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON \
                                -DCMAKE_TOOLCHAIN_FILE=${MXE_TOOLCHAIN} \
                                -DCMAKE_FIND_PREFIX_PATH=${CMAKE_PREFIX_PATH} \
                                -DCMAKE_SYSTEM_INCLUDE_PATH=${CMAKE_PREFIX_PATH}/include \
                                -DCMAKE_INCLUDE_PATH=${CMAKE_PREFIX_PATH}/include \
                                -DCMAKE_LIBRARY_PATH=${CMAKE_PREFIX_PATH}/lib \
                                -DZLIB_ROOT=${CMAKE_PREFIX_PATH}

if [ $? -ne 0 ]; then
    echo "---------- Cannot configure $LIB_NAME-$KD_VERSION."
    echo "---------- Aborting..."
    exit;
fi

echo -e "\n\n"
echo "---------- Building $LIB_NAME $KD_VERSION"
cd build

make -j$CPU_CORES
if [ $? -ne 0 ]; then
    echo "---------- Cannot compile $LIB_NAME-$KD_VERSION."
    echo "---------- Aborting..."
    exit;
fi

echo -e "\n\n"
echo "---------- Installing $LIB_NAME $KD_VERSION"
echo -e "\n\n"

make install/fast && cd "$ORIG_WD" && rm -rf "$DK_BUILDTEMP"
if [ $? -ne 0 ]; then
    echo "---------- Cannot install $LIB_NAME-$KD_VERSION."
    echo "---------- Aborting..."
    exit;
fi

}
