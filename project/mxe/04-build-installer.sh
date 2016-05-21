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
PROJECTDIR="$BUILDDIR/installer"

#################################################################################################
# Copy files

if [ -d "$PROJECTDIR" ]; then
    rm -fr $PROJECTDIR
    mkdir $PROJECTDIR
fi

mkdir -p $PROJECTDIR/share
mkdir -p $PROJECTDIR/translations
mkdir -p $PROJECTDIR/data

cp    $BUILDDIR/qt.conf                                                 $PROJECTDIR/

# Programs and shared libraries
cp    $MXE_INSTALL_PREFIX/bin/showfoto.exe                              $PROJECTDIR/
cp    $MXE_INSTALL_PREFIX/bin/digikam.exe                               $PROJECTDIR/
cp    $MXE_INSTALL_PREFIX/bin/kbuildsycoca5.exe                         $PROJECTDIR/
cp    $MXE_INSTALL_PREFIX/bin/*.dll                                     $PROJECTDIR/
find  $MXE_INSTALL_PREFIX/lib/plugins -name "*.dll" -type f -exec cp {} $PROJECTDIR/ \;

# Qt5
cp    $MXE_INSTALL_PREFIX/qt5/bin/*.dll                                 $PROJECTDIR/
cp -r $MXE_INSTALL_PREFIX/qt5/plugins                                   $PROJECTDIR/

# i18n
cp -r $MXE_INSTALL_PREFIX/qt5/translations/qt_*                         $PROJECTDIR/translations
cp -r $MXE_INSTALL_PREFIX/qt5/translations/qtbase*                      $PROJECTDIR/translations
cp -r $MXE_INSTALL_PREFIX/share/locale                                  $PROJECTDIR/data

# Marble
cp -r $MXE_INSTALL_PREFIX/plugins/*.dll                                 $PROJECTDIR/
cp -r $MXE_INSTALL_PREFIX/data/*                                        $PROJECTDIR/data

# GStreamer
cp -r $MXE_INSTALL_PREFIX/lib/gstreamer-1.0/*.dll                       $PROJECTDIR/

# Data files
cp -r $MXE_INSTALL_PREFIX/share/lensfun                                 $PROJECTDIR/data
cp -r $MXE_INSTALL_PREFIX/share/digikam                                 $PROJECTDIR/data
cp -r $MXE_INSTALL_PREFIX/share/showfoto                                $PROJECTDIR/data
cp -r $MXE_INSTALL_PREFIX/share/icons                                   $PROJECTDIR/data
cp -r $MXE_INSTALL_PREFIX/share/k*                                      $PROJECTDIR/data

#################################################################################################
# Cleanup^symbol in binary files to free space.

find $PROJECTDIR -name \*exe | xargs ${MXE_BUILDROOT}/usr/bin/${MXE_BUILD_TARGETS}-strip
find $PROJECTDIR -name \*dll | xargs ${MXE_BUILDROOT}/usr/bin/${MXE_BUILD_TARGETS}-strip

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
