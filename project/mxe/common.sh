#!/bin/bash

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
# Check CPU core available (Linux or MacOS)
ChecksCPUCores()
{

CPU_CORES=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || sysctl -n hw.ncpu)

if [[ $CPU_CORES -gt 1 ]]; then
    CPU_CORES=$((CPU_CORES-1))
fi

echo "CPU Cores to use : $CPU_CORES"

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
# arguments :
# $1: library name
# $2: path to patch to apply
# $3: configure options
#
InstallKDEExtraLib()
{

LIB_NAME=$1
PATCH=$2
OPTIONS=$3

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

if [ ! -z "$PATCH" ]; then
    echo "---------- Apply patch $PATCH to $LIB_NAME."
    patch -p1 < $PATCH
fi

echo -e "\n\n"
echo "---------- Configure $LIB_NAME with configure options : $OPTIONS"


rm -rf build
mkdir build
cd build

${MXE_BUILD_TARGETS}-cmake -G "Unix Makefiles" . \
                           -DBUILD_TESTING=OFF \
                           -DMXE_TOOLCHAIN=${MXE_TOOLCHAIN} \
                           -DCMAKE_BUILD_TYPE=relwithdebinfo \
                           -DCMAKE_COLOR_MAKEFILE=ON \
                           -DCMAKE_INSTALL_PREFIX=${MXE_INSTALL_PREFIX} \
                           -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON \
                           -DCMAKE_TOOLCHAIN_FILE=${MXE_TOOLCHAIN} \
                           -DCMAKE_FIND_PREFIX_PATH=${CMAKE_PREFIX_PATH} \
                           -DCMAKE_SYSTEM_INCLUDE_PATH=${CMAKE_PREFIX_PATH}/include \
                           -DCMAKE_INCLUDE_PATH=${CMAKE_PREFIX_PATH}/include \
                           -DCMAKE_LIBRARY_PATH=${CMAKE_PREFIX_PATH}/lib \
                           -DZLIB_ROOT=${CMAKE_PREFIX_PATH} \
                           $OPTIONS \
                           ..

if [ $? -ne 0 ]; then
    echo "---------- Cannot configure $LIB_NAME-$KD_VERSION."
    echo "---------- Aborting..."
    exit;
fi

echo -e "\n\n"
echo "---------- Building $LIB_NAME $KD_VERSION"

make -j$CPU_CORES

if [ $? -ne 0 ]; then
    echo "---------- Cannot compile $LIB_NAME-$KD_VERSION."
    echo "---------- Aborting..."
    exit;
fi

echo -e "\n\n"
echo "---------- Installing $LIB_NAME $KD_VERSION"
echo -e "\n\n"

make install/fast && cd "$ORIG_WD" && rm -rf "$KD_BUILDTEMP"

if [ $? -ne 0 ]; then
    echo "---------- Cannot install $LIB_NAME-$KD_VERSION."
    echo "---------- Aborting..."
    exit;
fi

}

########################################################################
# Install extra KF5 application
# arguments :
# $1: application name
# $2: path to patch to apply
# $3: configure options
#
InstallKDEExtraApp()
{

APP_NAME=$1
PATCH=$2
OPTIONS=$3

if [ -d "$KA_BUILDTEMP" ] ; then
    echo "---------- Removing existing $KA_BUILDTEMP"
    rm -rf "$KA_BUILDTEMP"
fi

echo "---------- Creating $KA_BUILDTEMP"
mkdir "$KA_BUILDTEMP"

if [ $? -ne 0 ]; then
    echo "---------- Cannot create $KA_BUILDTEMP directory."
    echo "---------- Aborting..."
    exit;
fi

cd "$KA_BUILDTEMP"
echo -e "\n\n"

echo "---------- Downloading $APP_NAME $KA_VERSION"
echo "---------- URL: $KD_URL/$KA_VERSION/$APP_NAME-$KA_VERSION.tar.xz"

curl -L -o "$APP_NAME-$KA_VERSION.tar.xz" "$KA_URL/$KA_VERSION/src/$APP_NAME-$KA_VERSION.tar.xz"

if [ $? -ne 0 ]; then
    echo "---------- Cannot download $APP_NAME-$KA_VERSION.tar.xz archive."
    echo "---------- Aborting..."
    exit;
fi

tar -xJf $APP_NAME-$KA_VERSION.tar.xz
if [ $? -ne 0 ]; then
    echo "---------- Cannot extract $APP_NAME-$KA_VERSION.tar.xz archive."
    echo "---------- Aborting..."
    exit;
fi

cd $APP_NAME-$KA_VERSION
pwd

if [ ! -z "$PATCH" ]; then
    echo "---------- Apply patch $PATCH to $APP_NAME."
    patch -p1 < $PATCH
fi

echo -e "\n\n"
echo "---------- Configure $APP_NAME with configure options : $OPTIONS"

rm -rf build
mkdir build
cd build

${MXE_BUILD_TARGETS}-cmake -G "Unix Makefiles" . \
                           -DBUILD_TESTING=OFF \
                           -DMXE_TOOLCHAIN=${MXE_TOOLCHAIN} \
                           -DCMAKE_BUILD_TYPE=relwithdebinfo \
                           -DCMAKE_COLOR_MAKEFILE=ON \
                           -DCMAKE_INSTALL_PREFIX=${MXE_INSTALL_PREFIX} \
                           -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON \
                           -DCMAKE_TOOLCHAIN_FILE=${MXE_TOOLCHAIN} \
                           -DCMAKE_FIND_PREFIX_PATH=${CMAKE_PREFIX_PATH} \
                           -DCMAKE_SYSTEM_INCLUDE_PATH=${CMAKE_PREFIX_PATH}/include \
                           -DCMAKE_INCLUDE_PATH=${CMAKE_PREFIX_PATH}/include \
                           -DCMAKE_LIBRARY_PATH=${CMAKE_PREFIX_PATH}/lib \
                           -DZLIB_ROOT=${CMAKE_PREFIX_PATH} \
                           $OPTIONS \
                           ..

if [ $? -ne 0 ]; then
    echo "---------- Cannot configure $APP_NAME-$KA_VERSION."
    echo "---------- Aborting..."
    exit;
fi

echo -e "\n\n"
echo "---------- Building $APP_NAME $KA_VERSION"

make -j$CPU_CORES

if [ $? -ne 0 ]; then
    echo "---------- Cannot compile $APP_NAME-$KA_VERSION."
    echo "---------- Aborting..."
    exit;
fi

echo -e "\n\n"
echo "---------- Installing $APP_NAME $KA_VERSION"
echo -e "\n\n"

make install/fast && cd "$ORIG_WD" && rm -rf "$KA_BUILDTEMP"

if [ $? -ne 0 ]; then
    echo "---------- Cannot install $APP_NAME-$KA_VERSION."
    echo "---------- Aborting..."
    exit;
fi

}

########################################################################
# Install extra KF5 component from git
# arguments :
# $1: git url
# $2: path to patch to apply
# $3: configure options
#
InstallKDEExtraComponentFromGit()
{

COMPONENT=$1
PATCH=$2
OPTIONS=$3

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

echo "---------- Downloading $COMPONENT"

git clone git@git.kde.org:$COMPONENT

if [ $? -ne 0 ]; then
    echo "---------- Cannot download $COMPONENT."
    echo "---------- Aborting..."
    exit;
fi

cd $COMPONENT
pwd

if [ ! -z "$PATCH" ]; then
    echo "---------- Apply patch $PATCH to $LIB_NAME."
    patch -p1 < $PATCH
fi

echo -e "\n\n"
echo "---------- Configure $COMPONENT with configure options : $OPTIONS"

rm -rf build
mkdir build
cd build

${MXE_BUILD_TARGETS}-cmake -G "Unix Makefiles" . \
                           -DBUILD_TESTING=OFF \
                           -DMXE_TOOLCHAIN=${MXE_TOOLCHAIN} \
                           -DCMAKE_BUILD_TYPE=relwithdebinfo \
                           -DCMAKE_COLOR_MAKEFILE=ON \
                           -DCMAKE_INSTALL_PREFIX=${MXE_INSTALL_PREFIX} \
                           -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON \
                           -DCMAKE_TOOLCHAIN_FILE=${MXE_TOOLCHAIN} \
                           -DCMAKE_FIND_PREFIX_PATH=${CMAKE_PREFIX_PATH} \
                           -DCMAKE_SYSTEM_INCLUDE_PATH=${CMAKE_PREFIX_PATH}/include \
                           -DCMAKE_INCLUDE_PATH=${CMAKE_PREFIX_PATH}/include \
                           -DCMAKE_LIBRARY_PATH=${CMAKE_PREFIX_PATH}/lib \
                           -DZLIB_ROOT=${CMAKE_PREFIX_PATH} \
                           $OPTIONS \
                           ..

if [ $? -ne 0 ]; then
    echo "---------- Cannot configure $COMPONENT."
    echo "---------- Aborting..."
    exit;
fi

echo -e "\n\n"
echo "---------- Building $COMPONENT"

make -j$CPU_CORES

if [ $? -ne 0 ]; then
    echo "---------- Cannot compile $COMPONENT."
    echo "---------- Aborting..."
    exit;
fi

echo -e "\n\n"
echo "---------- Installing $COMPONENT"
echo -e "\n\n"

make install/fast && cd "$ORIG_WD" && rm -rf "$KD_BUILDTEMP"

if [ $? -ne 0 ]; then
    echo "---------- Cannot install $COMPONENT."
    echo "---------- Aborting..."
    exit;
fi

}
