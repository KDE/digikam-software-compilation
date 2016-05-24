#! /bin/bash

# Script to bundle data using previously-built KDE and digiKam installation
# and create a Windows installer file with NSIS application
# Dependency : NSIS makensis program for Linux.
#
# Copyright (c) 2015-2016, Gilles Caulier, <caulier dot gilles at gmail dot com>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.
#

#################################################################################################
# Manage script traces to log file

exec > >(tee build-installer.full.log) 2>&1

#################################################################################################

echo "04-build-installer.sh : build digiKam Windows installer."
echo "--------------------------------------------------------"

#################################################################################################
# Pre-processing checks

. ./configbundlemxe.sh
. ./common.sh
StartScript
ChecksCPUCores

#################################################################################################
# Check if NSIS CLI tools id installed

if ! which makensis ; then
    echo "NSIS CLI tool is not installed"
    echo "See http://nsis.sourceforge.net/ for details."
    exit 1
else
    echo "Check NSIS CLI tools passed..."
fi

#################################################################################################
# Configurations

# Directory where this script is located (default - current directory)
BUILDDIR="$PWD"

# Directory where installer files are located
BUNDLEDIR="$BUILDDIR/bundle"

ORIG_WD="`pwd`"

#################################################################################################
# Build icons-set ressource

echo -e "\n---------- Build icons-set ressource\n"

cd $ORIG_WD/icon-rcc

cmake -DCMAKE_INSTALL_PREFIX="$MXE_INSTALL_PREFIX" \
      -DCMAKE_BUILD_TYPE=debug \
      -DCMAKE_COLOR_MAKEFILE=ON \
      .

make -j$CPU_CORES

#################################################################################################
# Copy files

echo -e "\n---------- Copy files in bundle directory\n"

cd $ORIG_WD

if [ -d "$BUNDLEDIR" ]; then
    rm -fr $BUNDLEDIR
    mkdir $BUNDLEDIR
fi

mkdir -p $BUNDLEDIR/translations
mkdir -p $BUNDLEDIR/data

cp    $BUILDDIR/qt.conf                                                 $BUNDLEDIR/
cp    $BUILDDIR/icon-rcc/breeze.rcc                                     $BUNDLEDIR/

# Programs
cp    $MXE_INSTALL_PREFIX/bin/showfoto.exe                              $BUNDLEDIR/
cp    $MXE_INSTALL_PREFIX/bin/digikam.exe                               $BUNDLEDIR/
cp    $MXE_INSTALL_PREFIX/bin/kbuildsycoca5.exe                         $BUNDLEDIR/
cp    $MXE_INSTALL_PREFIX/bin/kioexec.exe                               $BUNDLEDIR/
cp    $MXE_INSTALL_PREFIX/bin/kioslave.exe                              $BUNDLEDIR/
cp    $MXE_INSTALL_PREFIX/bin/dbus-daemon.exe                           $BUNDLEDIR/
cp    $MXE_INSTALL_PREFIX/bin/dbus-lauch.exe                            $BUNDLEDIR/
cp    $MXE_INSTALL_PREFIX/bin/dbus-send.exe                             $BUNDLEDIR/

# Shared libraries
cp    $MXE_INSTALL_PREFIX/bin/*.dll                                     $BUNDLEDIR/
find  $MXE_INSTALL_PREFIX/lib/plugins -name "*.dll" -type f -exec cp {} $BUNDLEDIR/ \;

# Qt5
cp    $MXE_INSTALL_PREFIX/qt5/bin/*.dll                                 $BUNDLEDIR/
cp -r $MXE_INSTALL_PREFIX/qt5/plugins                                   $BUNDLEDIR/

# i18n
cp -r $MXE_INSTALL_PREFIX/qt5/translations/qt_*                         $BUNDLEDIR/translations
cp -r $MXE_INSTALL_PREFIX/qt5/translations/qtbase*                      $BUNDLEDIR/translations
cp -r $MXE_INSTALL_PREFIX/share/locale                                  $BUNDLEDIR/data

# Marble
cp -r $MXE_INSTALL_PREFIX/plugins/*.dll                                 $BUNDLEDIR/
cp -r $MXE_INSTALL_PREFIX/data/*                                        $BUNDLEDIR/data

# GStreamer
cp -r $MXE_INSTALL_PREFIX/lib/gstreamer-1.0/*.dll                       $BUNDLEDIR/

# Data files
cp -r $MXE_INSTALL_PREFIX/share/lensfun                                 $BUNDLEDIR/data
cp -r $MXE_INSTALL_PREFIX/share/digikam                                 $BUNDLEDIR/data
cp -r $MXE_INSTALL_PREFIX/share/showfoto                                $BUNDLEDIR/data
cp -r $MXE_INSTALL_PREFIX/share/k*                                      $BUNDLEDIR/data

#################################################################################################
# Cleanup^symbol in binary files to free space.

echo -e "\n---------- Strip symbols in binary files\n"

find $BUNDLEDIR -name \*exe | xargs ${MXE_BUILDROOT}/usr/bin/${MXE_BUILD_TARGETS}-strip
find $BUNDLEDIR -name \*dll | xargs ${MXE_BUILDROOT}/usr/bin/${MXE_BUILD_TARGETS}-strip

#################################################################################################
# Build NSIS installer.

echo -e "\n---------- Build NSIS installer\n"

cd $ORIG_WD/installer

if [ $MXE_BUILD_TARGETS == "i686-w64-mingw32.shared" ]; then
    TARGET_INSTALLER=digiKam-installer-$DK_VERSION-win32.exe
else
    TARGET_INSTALLER=digiKam-installer-$DK_VERSION-win64.exe
fi

makensis -DVERSION=$DK_VERSION -DBUNDLEPATH=../bundle -DOUTPUT=$TARGET_INSTALLER ./digikam.nsi

#################################################################################################
# Show resume information and future instructions to host installer file to KDE server

echo -e "\n---------- Compute package checksums for digiKam $DK_VERSION\n"

echo    "File       : $TARGET_INSTALLER"
echo -n "Size       : "
du -h "$TARGET_INSTALLER" | { read first rest ; echo $first ; }
echo -n "MD5 sum    : "
md5sum "$TARGET_INSTALLER"
echo -n "SHA1 sum   : "
shasum -a1 "$TARGET_INSTALLER" | { read first rest ; echo $first ; }
echo -n "SHA256 sum : "
shasum -a256 "$TARGET_INSTALLER" | { read first rest ; echo $first ; }

echo -e "\n------------------------------------------------------------------"
curl http://download.kde.org/README_UPLOAD
echo -e "------------------------------------------------------------------\n"

#################################################################################################

TerminateScript
