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

# Halt on error
set -e

#################################################################################################
# Manage script traces to log file

mkdir -p ./logs
exec > >(tee ./logs/build-installer.full.log) 2>&1

#################################################################################################

echo "04-build-installer.sh : build digiKam Windows installer."
echo "--------------------------------------------------------"

#################################################################################################
# Pre-processing checks

. ./config.sh
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

DK_RELEASEID=`cat $ORIG_WD/data/RELEASEID.txt`

#################################################################################################
# Build icons-set ressource

echo -e "\n---------- Build icons-set ressource\n"

cd $ORIG_WD/icon-rcc

rm -f CMakeCache.txt > /dev/null

cmake -DCMAKE_INSTALL_PREFIX="$MXE_INSTALL_PREFIX" \
      -DCMAKE_BUILD_TYPE=debug \
      -DCMAKE_COLOR_MAKEFILE=ON \
      -Wno-dev \
      .

make -j$CPU_CORES

#################################################################################################
# Copy files

echo -e "\n---------- Copy files in bundle directory\n"

# Directories creation -----------------------------------------------------------------------

cd $ORIG_WD

if [ -d "$BUNDLEDIR" ]; then
    rm -fr $BUNDLEDIR
    mkdir $BUNDLEDIR
fi

mkdir -p $BUNDLEDIR/data
mkdir -p $BUNDLEDIR/etc
mkdir -p $BUNDLEDIR/share
mkdir -p $BUNDLEDIR/translations

# Data files ---------------------------------------------------------------------------------

echo -e "\n---------- Marble data"
cp -r $MXE_INSTALL_PREFIX/data/*                                        $BUNDLEDIR/data         2>/dev/null

echo -e "\n---------- Generics data"
cp -r $MXE_INSTALL_PREFIX/share/lensfun                                 $BUNDLEDIR/data         2>/dev/null
cp -r $MXE_INSTALL_PREFIX/bin/data/digikam                              $BUNDLEDIR/data         2>/dev/null
cp -r $MXE_INSTALL_PREFIX/bin/data/showfoto                             $BUNDLEDIR/data         2>/dev/null
cp -r $MXE_INSTALL_PREFIX/bin/data/solid                                $BUNDLEDIR/data         2>/dev/null
cp -r $MXE_INSTALL_PREFIX/bin/data/k*                                   $BUNDLEDIR/data         2>/dev/null

echo -e "\n---------- Qt config"
cp    $BUILDDIR/data/qt.conf                                            $BUNDLEDIR/             2>/dev/null

echo -e "\n---------- icons-set"
cp    $BUILDDIR/icon-rcc/breeze.rcc                                     $BUNDLEDIR/             2>/dev/null

echo -e "\n---------- i18n"
cp -r $MXE_INSTALL_PREFIX/qt5/translations/qt_*                         $BUNDLEDIR/translations 2>/dev/null
cp -r $MXE_INSTALL_PREFIX/qt5/translations/qtbase*                      $BUNDLEDIR/translations 2>/dev/null
cp -r $MXE_INSTALL_PREFIX/bin/data/locale                               $BUNDLEDIR/data         2>/dev/null

echo -e "\n---------- Xdg"
cp -r $MXE_INSTALL_PREFIX/etc/xdg                                       $BUNDLEDIR/etc          2>/dev/null
cp -r $MXE_INSTALL_PREFIX/bin/data/xdg                                  $BUNDLEDIR/share        2>/dev/null

# Plugins Shared libraries -------------------------------------------------------------------

echo -e "\n---------- Marble plugins"
cp -r $MXE_INSTALL_PREFIX/plugins/*.dll                                 $BUNDLEDIR/             2>/dev/null

echo -e "\n---------- Qt5 plugins"
cp -r $MXE_INSTALL_PREFIX/qt5/plugins                                   $BUNDLEDIR/             2>/dev/null

echo -e "\n---------- KF5 plugins"
find  $MXE_INSTALL_PREFIX/lib/plugins -name "*.dll" -type f -exec cp {} $BUNDLEDIR/ \;          2>/dev/null

echo -e "\n---------- Copy executables with recursive dependencies in bundle directory\n"

# Executables and plugins shared libraries dependencies scan ---------------------------------

EXE_FILES="\
gdb.exe \
digikam.exe \
showfoto.exe \
kbuildsycoca5.exe \
"

for app in $EXE_FILES ; do

    cp $MXE_INSTALL_PREFIX/bin/$app $BUNDLEDIR/
    $ORIG_WD/rll.py --copy --installprefix $MXE_INSTALL_PREFIX --odir $BUNDLEDIR --efile $BUNDLEDIR/$app

done

DLL_FILES="\
`find  $MXE_INSTALL_PREFIX/lib/plugins -name "*.dll" -type f -exec basename {} \; | sed "s|^|$BUNDLEDIR/|"` \
`find  $MXE_INSTALL_PREFIX/qt5/plugins -name "*.dll" -type f | sed 's|$MXE_INSTALL_PREFIX/qt5/||'`          \
`find  $MXE_INSTALL_PREFIX/plugins     -name "*.dll" -type f | sed 's|$MXE_INSTALL_PREFIX/plugins/||'`      \
"

for app in $DLL_FILES ; do

    $ORIG_WD/rll.py --copy --installprefix $MXE_INSTALL_PREFIX --odir $BUNDLEDIR --efile $app

done

#################################################################################################
# Cleanup symbols in binary files to free space.

echo -e "\n---------- Strip symbols in binary files\n"

find $BUNDLEDIR -name \*exe | xargs ${MXE_BUILDROOT}/usr/bin/${MXE_BUILD_TARGETS}-strip
find $BUNDLEDIR -name \*dll | xargs ${MXE_BUILDROOT}/usr/bin/${MXE_BUILD_TARGETS}-strip

#################################################################################################
# Build NSIS installer.

echo -e "\n---------- Build NSIS installer\n"

cd $ORIG_WD/installer

if [ $MXE_BUILD_TARGETS == "i686-w64-mingw32.shared" ]; then
    TARGET_INSTALLER=digiKam-$DK_RELEASEID$DK_EPOCH-Win32.exe
else
    TARGET_INSTALLER=digiKam-$DK_RELEASEID$DK_EPOCH-Win64.exe
fi

makensis -DVERSION=$DK_RELEASEID -DBUNDLEPATH=../bundle -DTARGETARCH=$MXE_ARCHBITS -DOUTPUT=$TARGET_INSTALLER ./digikam.nsi

#################################################################################################
# Show resume information and future instructions to host installer file to KDE server

echo -e "\n---------- Compute package checksums for digiKam $DK_RELEASEID\n"  > $TARGET_INSTALLER.txt
echo    "File       : $TARGET_INSTALLER"                                     >> $TARGET_INSTALLER.txt
echo -n "Size       : "                                                      >> $TARGET_INSTALLER.txt
du -h "$TARGET_INSTALLER"        | { read first rest ; echo $first ; }       >> $TARGET_INSTALLER.txt
echo -n "MD5 sum    : "                                                      >> $TARGET_INSTALLER.txt
md5sum "$TARGET_INSTALLER"       | { read first rest ; echo $first ; }       >> $TARGET_INSTALLER.txt
echo -n "SHA1 sum   : "                                                      >> $TARGET_INSTALLER.txt
shasum -a1 "$TARGET_INSTALLER"   | { read first rest ; echo $first ; }       >> $TARGET_INSTALLER.txt
echo -n "SHA256 sum : "                                                      >> $TARGET_INSTALLER.txt
shasum -a256 "$TARGET_INSTALLER" | { read first rest ; echo $first ; }       >> $TARGET_INSTALLER.txt

cat $TARGET_INSTALLER.txt
echo -e "\n------------------------------------------------------------------"
curl http://download.kde.org/README_UPLOAD
echo -e "------------------------------------------------------------------\n"

#################################################################################################

TerminateScript
