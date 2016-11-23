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

export MACOSX_DEPLOYMENT_TARGET=$OSX_MIN_TARGET

OSX_MAJOR=`echo $MACOSX_DEPLOYMENT_TARGET | awk -F '.' '{print $1 "." $2}'| cut -d . -f 2`

if [[ $OSX_MAJOR -lt 9 ]]; then
    export CXXFLAGS=-stdlib=libc++
fi

echo "Target OSX minimal version: $MACOSX_DEPLOYMENT_TARGET"
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
# Fix QStandardPaths problem with non bundle like place to sore data under OSX.
FixApplicationBundleDataPath()
{

LC_CTYPE=C find . -name "*.cpp" -type f -exec sed -i '' -e 's/GenericDataLocation/AppDataLocation/g' {} \;

}

########################################################################
# Set strings with detected MacOS info :
#    $MAJOR_OSX_VERSION : detected MacOS major ID (as 7 for 10.7 or 10 for 10.10)
#    $OSX_CODE_NAME     : detected MacOS code name
OsxCodeName()
{

MAJOR_OSX_VERSION=$(sw_vers -productVersion | awk -F '.' '{print $1 "." $2}'| cut -d . -f 2)

if [[ $MAJOR_OSX_VERSION == "12" ]]
    then OSX_CODE_NAME="Sierra"
elif [[ $MAJOR_OSX_VERSION == "11" ]]
    then OSX_CODE_NAME="ElCapitan"
elif [[ $MAJOR_OSX_VERSION == "10" ]]
    then OSX_CODE_NAME="Yosemite"
elif [[ $MAJOR_OSX_VERSION == "9" ]]
    then OSX_CODE_NAME="Mavericks"
elif [[ $MAJOR_OSX_VERSION == "8" ]]
    then OSX_CODE_NAME="MountainLion"
elif [[ $MAJOR_OSX_VERSION == "7" ]]
    then OSX_CODE_NAME="Lion"
elif [[ $MAJOR_OSX_VERSION == "6" ]]
    then OSX_CODE_NAME="SnowLeopard"
elif [[ $MAJOR_OSX_VERSION == "5" ]]
    then OSX_CODE_NAME="Leopard"
elif [[ $MAJOR_OSX_VERSION == "4" ]]
    then OSX_CODE_NAME="Tiger"
elif [[ $MAJOR_OSX_VERSION == "3" ]]
    then OSX_CODE_NAME="Panther"
elif [[ $MAJOR_OSX_VERSION == "2" ]]
    then OSX_CODE_NAME="Jaguar"
elif [[ $MAJOR_OSX_VERSION == "1" ]]
    then OSX_CODE_NAME="Puma"
elif [[ $MAJOR_OSX_VERSION == "0" ]]
    then OSX_CODE_NAME="Cheetah"
fi

echo -e "---------- Detected OSX version 10.$MAJOR_OSX_VERSION and code name $OSX_CODE_NAME"

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

FixApplicationBundleDataPath

echo -e "\n\n"
echo "---------- Configure $LIB_NAME with configure options : $OPTIONS"

rm -rf build
mkdir build

cp $ORIG_WD/../../bootstrap.macports ./

./bootstrap.macports "$INSTALL_PREFIX" "debugfull" "x86_64" $OPTIONS

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

FixApplicationBundleDataPath

echo -e "\n\n"
echo "---------- Configure $APP_NAME with configure options : $OPTIONS"

rm -rf build
mkdir build

cp $ORIG_WD/../../bootstrap.macports ./

./bootstrap.macports "$INSTALL_PREFIX" "debugfull" "x86_64" $OPTIONS

if [ $? -ne 0 ]; then
    echo "---------- Cannot configure $APP_NAME-$KA_VERSION."
    echo "---------- Aborting..."
    exit;
fi

echo -e "\n\n"
echo "---------- Building $APP_NAME $KA_VERSION"

cd build
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
# Install Macports core packages before to compile digiKam
# See https://trac.macports.org/wiki/KDE for details
# Possible arguments : 
#     DISABLE_LENSFUN  : do not install LibLensFun through Macports.
#     CONTINUE_INSTALL : Continue aborted previous installation.
#
InstallCorePackages()
{

OsxCodeName

# With OSX less than El Capitan, we need a more recent Clang compiler than one provided by XCode.

if [[ $MAJOR_OSX_VERSION -lt 10 ]]; then

    echo "---------- Install more recent Clang compiler from Macports for specific ports"
    port install clang_select
    port install clang-3.4
    port select --set clang mp-clang-3.4
fi

echo -e "\n"

port install $MP_PACKAGES

}
