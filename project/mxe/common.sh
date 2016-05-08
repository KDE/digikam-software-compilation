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
# Check if Xcode Command Line tools are installed
ChecksXCodeCLI()
{

xcode-select --print-path

if [[ $? -ne 0 ]]; then
    echo "XCode CLI tools are not installed"
    echo "See http://www.macports.org/install.php for details."
    exit 1
else
    echo "Check XCode CLI tools passed..."
fi

}

########################################################################
# Check if Macports is installed
ChecksMacports()
{

which port

if [[ $? -ne 0 ]]; then
    echo "Macports is not installed"
    echo "See http://www.macports.org/install.php for details."
    exit 1
else
    echo "Check Macports passed..."
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

echo -e "\n\n"
echo "---------- Configure $LIB_NAME with CXX extra flags : $EXTRA_CXX_FLAGS"

x86_64-w64-mingw32.shared-cmake -G "Unix Makefiles" . \
                                -DCMAKE_BUILD_TYPE=debug \
                                -DBUILD_TESTING=OFF \
                                -DCMAKE_COLOR_MAKEFILE=ON \
                                -DCMAKE_INSTALL_PREFIX=$MXE_BUILDROOT/mxe/usr/x86_64-w64-mingw32.shared/ \
                                -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON \
                                -DINSTALL_ROOT=$MXE_BUILDROOT/mxe/usr/x86_64-w64-mingw32.shared \
                                -DMXE_TOOLCHAIN=${MXE_BUILDROOT}/mxe/usr/x86_64-w64-mingw32.shared/share/cmake/mxe-conf.cmake \
                                ..

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
