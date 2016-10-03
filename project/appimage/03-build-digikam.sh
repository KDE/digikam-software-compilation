#! /bin/bash

# Script to build digiKam under Linux
# This script must be run as sudo
#
# Copyright (c) 2015-2016, Gilles Caulier, <caulier dot gilles at gmail dot com>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.
#

#################################################################################################
# Pre-processing checks

. ./config.sh
. ./common.sh
StartScript
ChecksCPUCores
ChecksRunAsRoot

# Halt on error
set -e

#################################################################################################
# Manage script traces to log file

mkdir -p ./logs
exec > >(tee ./logs/build-digikam.full.log) 2>&1

#################################################################################################

echo "03-build-digikam.sh : build digiKam for Linux."
echo "---------------------------------------------------"

# Now we are inside CentOS 6
grep -r "CentOS release 6" /etc/redhat-release || exit 1

# qjsonparser, used to add metadata to the plugins needs to work in a en_US.UTF-8 environment. That's
# not always set correctly in CentOS 6.7
export LC_ALL=en_US.UTF-8
export LANG=en_us.UTF-8

# Determine which architecture should be built
if [[ "$(arch)" = "i686" || "$(arch)" = "x86_64" ]] ; then
  ARCH=$(arch)
else
  echo "Architecture could not be determined"
  exit 1
fi

# if the library path doesn't point to our usr/lib, linking will be broken and we won't find all deps either
export LD_LIBRARY_PATH=/usr/lib64/:/usr/lib:/krita.appdir/usr/lib

. /opt/rh/devtoolset-4/enable

#################################################################################################

# Pathes rules
ORIG_PATH="$PATH"
ORIG_WD="`pwd`"

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

git clone git://anongit.kde.org/digikam-software-compilation.git digikam-$DK_VERSION
cd digikam-$DK_VERSION
export GITSLAVE=".gitslave.devel"
./download-repos

if [ $? -ne 0 ] ; then
    echo "---------- Cannot clone repositories."
    echo "---------- Aborting..."
    exit;
fi

cd ./core 
git checkout $DK_VERSION
cd ../extra/kipi-plugins
git checkout $DK_VERSION
cd ../..

echo -e "\n\n"
echo "---------- Configure digiKam $DK_VERSION"

rm -rf build
mkdir build

#sed -e "s/DIGIKAMSC_CHECKOUT_PO=OFF/DIGIKAMSC_CHECKOUT_PO=ON/g"                       ./bootstrap.linux > ./tmp.linux ; mv -f ./tmp.linux ./bootstrap.linux
#sed -e "s/DIGIKAMSC_COMPILE_PO=OFF/DIGIKAMSC_COMPILE_PO=ON/g"                         ./bootstrap.linux > ./tmp.linux ; mv -f ./tmp.linux ./bootstrap.linux
#sed -e "s/DBUILD_TESTING=ON/DBUILD_TESTING=OFF/g"                                     ./bootstrap.linux > ./tmp.linux ; mv -f ./tmp.linux ./bootstrap.linux
#sed -e "s/DDIGIKAMSC_COMPILE_LIBKSANE=ON/DDIGIKAMSC_COMPILE_LIBKSANE=OFF/g"           ./bootstrap.linux > ./tmp.linux ; mv -f ./tmp.linux ./bootstrap.linux
#sed -e "s/DDIGIKAMSC_COMPILE_LIBKVKONTAKTE=ON/DDIGIKAMSC_COMPILE_LIBKVKONTAKTE=OFF/g" ./bootstrap.linux > ./tmp.linux ; mv -f ./tmp.linux ./bootstrap.linux

#chmod +x ./bootstrap.linux

#./bootstrap.linux 

cd build

cmake3 -G "Unix Makefiles" .. \
      -DCMAKE_BUILD_TYPE=debug \
      -DCMAKE_INSTALL_PREFIX=`qtpaths --install-prefix 2>/dev/null` \
      -DKDE_INSTALL_QTPLUGINDIR=`qtpaths --plugin-dir` \
      -DBUILD_TESTING=OFF \
      -DDIGIKAMSC_CHECKOUT_PO=OFF \
      -DDIGIKAMSC_CHECKOUT_DOC=OFF \
      -DDIGIKAMSC_COMPILE_PO=OFF \
      -DDIGIKAMSC_COMPILE_DOC=OFF \
      -DDIGIKAMSC_COMPILE_DIGIKAM=ON \
      -DDIGIKAMSC_COMPILE_KIPIPLUGINS=ON \
      -DDIGIKAMSC_COMPILE_LIBKIPI=ON \
      -DDIGIKAMSC_COMPILE_LIBKSANE=OFF \
      -DDIGIKAMSC_COMPILE_LIBMEDIAWIKI=ON \
      -DDIGIKAMSC_COMPILE_LIBKVKONTAKTE=OFF \
      -DENABLE_OPENCV3=ON \
      -DENABLE_KFILEMETADATASUPPORT=OFF \
      -DENABLE_AKONADICONTACTSUPPORT=OFF \
      -DENABLE_MYSQLSUPPORT=ON \
      -DENABLE_INTERNALMYSQL=ON \
      -DENABLE_MEDIAPLAYER=OFF \
      -DENABLE_DBUS=ON \
      -DENABLE_APPSTYLES=ON

if [ $? -ne 0 ]; then
    echo "---------- Cannot configure digiKam $DK_VERSION."
    echo "---------- Aborting..."
    exit;
fi

if [ -d ./extra/libkvkontakte/src ]; then
    ln -sf src ./extra/libkvkontakte/Vkontakte
fi

if [ -d ./extra/libmediawiki/src ]; then
    ln -sf src ./extra/libmediawiki/MediaWiki
fi

echo -e "\n\n"
echo "---------- Building digiKam $DK_VERSION"

make -j$CPU_CORES

if [ $? -ne 0 ]; then
    echo "---------- Cannot compile digiKam $DK_VERSION."
    echo "---------- Aborting..."
    exit;
fi

echo -e "\n\n"
echo "---------- Installing digiKam $DK_VERSION"
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
