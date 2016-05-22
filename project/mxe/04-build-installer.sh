#! /bin/bash

# Script to bundle data using previously-built KDE and digiKam installation
# and create a Windows installer file with NSIS application
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
# Configurations

# Directory where this script is located (default - current directory)
BUILDDIR="$PWD"

# Directory where installer files are located
BUNDLEDIR="$BUILDDIR/bundle"

#################################################################################################
# Copy files

echo -e "\n---------- Copy files in bundle directory\n"

if [ -d "$BUNDLEDIR" ]; then
    rm -fr $BUNDLEDIR
    mkdir $BUNDLEDIR
fi

mkdir -p $BUNDLEDIR/share
mkdir -p $BUNDLEDIR/translations
mkdir -p $BUNDLEDIR/data

cp    $BUILDDIR/qt.conf                                                 $BUNDLEDIR/

# Programs and shared libraries
cp    $MXE_INSTALL_PREFIX/bin/showfoto.exe                              $BUNDLEDIR/
cp    $MXE_INSTALL_PREFIX/bin/digikam.exe                               $BUNDLEDIR/
cp    $MXE_INSTALL_PREFIX/bin/kbuildsycoca5.exe                         $BUNDLEDIR/
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
cp -r $MXE_INSTALL_PREFIX/share/icons                                   $BUNDLEDIR/data
cp -r $MXE_INSTALL_PREFIX/share/k*                                      $BUNDLEDIR/data

#################################################################################################
# Cleanup^symbol in binary files to free space.

echo -e "\n---------- Strip symbols in binary files\n"

find $BUNDLEDIR -name \*exe | xargs ${MXE_BUILDROOT}/usr/bin/${MXE_BUILD_TARGETS}-strip
find $BUNDLEDIR -name \*dll | xargs ${MXE_BUILDROOT}/usr/bin/${MXE_BUILD_TARGETS}-strip

exit

#################################################################################################
# Show resume information and future instructions to host PKG file to KDE server

echo -e "\n---------- Compute package checksums for digiKam $DIGIKAM_VERSION\n"

echo "File       : $TARGET_PKG_FILE"
echo -n "Size       : "
du -h "$TARGET_PKG_FILE" | { read first rest ; echo $first ; }
echo -n "MD5 sum    : "
md5 -q "$TARGET_PKG_FILE"
echo -n "SHA1 sum   : "
shasum -a1 "$TARGET_PKG_FILE" | { read first rest ; echo $first ; }
echo -n "SHA256 sum : "
shasum -a256 "$TARGET_PKG_FILE" | { read first rest ; echo $first ; }

echo -e "\n------------------------------------------------------------------"
curl http://download.kde.org/README_UPLOAD
echo -e "------------------------------------------------------------------\n"

#################################################################################################

TerminateScript
