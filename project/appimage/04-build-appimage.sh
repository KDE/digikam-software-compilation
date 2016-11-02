#!/bin/bash

# Script to bundle data using previously-built KF5 with digiKam installation
# and create a Linux AppImage bundle file.
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
exec > >(tee ./logs/build-appimage.full.log) 2>&1

#################################################################################################

echo "04-build-appimage.sh : build digiKam AppImage bundle."
echo "-----------------------------------------------------"

#################################################################################################
# Pre-processing checks

. ./config.sh
. ./common.sh
StartScript
ChecksCPUCores
ChecksRunAsRoot
CentOS6Adjustments
. /opt/rh/devtoolset-3/enable

if [[ "$(arch)" = "x86_64" ]] ; then
    LIB_PATH_ALT=lib64
else
    LIB_PATH_ALT=lib
fi

#################################################################################################

# Working directory
ORIG_WD="`pwd`"
APP_IMG_DIR="/digikam.appdir"

DK_RELEASEID=`cat $ORIG_WD/data/RELEASEID.txt`

#################################################################################################

echo -e "---------- Build icons-set ressource\n"

cd $ORIG_WD/icon-rcc

rm -f CMakeCache.txt > /dev/null

cmake3 -DCMAKE_INSTALL_PREFIX="/usr" \
       -DCMAKE_BUILD_TYPE=debug \
       -DCMAKE_COLOR_MAKEFILE=ON \
       -Wno-dev \
       .

make -j$CPU_CORES

#################################################################################################

echo -e "---------- Prepare directories in bundle\n"

# Make sure we build from the /, parts of this script depends on that. We also need to run as root...
cd /

# Prepare the install location
rm -rf $APP_IMG_DIR/ || true
mkdir -p $APP_IMG_DIR/usr/bin
mkdir -p $APP_IMG_DIR/usr/share
mkdir -p $APP_IMG_DIR/usr/share/metainfo
mkdir -p $APP_IMG_DIR/usr/share/dbus-1/interfaces
mkdir -p $APP_IMG_DIR/usr/share/dbus-1/services

# make sure lib and lib64 are the same thing
mkdir -p $APP_IMG_DIR/usr/lib
mkdir -p $APP_IMG_DIR/usr/lib/libexec
cd $APP_IMG_DIR/usr
ln -s lib lib64

#################################################################################################

echo -e "---------- Copy Files in bundle\n"

cd $APP_IMG_DIR

# FIXME: How to find out which subset of plugins is really needed? I used strace when running the binary
cp -r /usr/plugins ./usr/
rm -fr ./usr/plugins/ktexteditor
rm -fr ./usr/plugins/kf5/parts
rm -fr ./usr/plugins/konsolepart.so

# copy runtime data files
cp -r /usr/share/digikam                 ./usr/share
cp $ORIG_WD/icon-rcc/breeze.rcc          ./usr/share/digikam
cp $ORIG_WD/data/qt.conf                 ./usr/bin
cp -r /usr/share/lensfun                 ./usr/share
cp -r /usr/share/kipiplugin*             ./usr/share
cp -r /usr/share/knotifications5         ./usr/share
cp -r /usr/share/kservices5              ./usr/share
cp -r /usr/share/kservicetypes5          ./usr/share
cp -r /usr/share/kxmlgui5                ./usr/share
cp -r /usr/share/kf5                     ./usr/share
cp -r /usr/share/solid                   ./usr/share
cp -r /usr/share/OpenCV                  ./usr/share
cp -r /usr/share/metainfo/*digikam*      ./usr/share/metainfo/
cp -r /usr/share/metainfo/*showfoto*     ./usr/share/metainfo/
cp -r /usr/share/dbus-1/interfaces/kf5*  ./usr/share/dbus-1/interfaces/
cp -r /usr/share/dbus-1/services/*kde*   ./usr/share/dbus-1/services/
cp -r /usr/$LIB_PATH_ALT/libexec/kf5     ./usr/lib/libexec/
# copy i18n

# Qt translations files
cp -r /usr/translations                  ./usr

# KF5 translations files
FILES=$(cat $ORIG_WD/logs/build-extralibs.full.log |grep /usr/share/locale/ | cut -d' ' -f3)

for FILE in $FILES ; do
    cp --parents $FILE ./
done

# digiKam translations files
FILES=$(cat $ORIG_WD/logs/build-digikam.full.log |grep /usr/share/locale/ | cut -d' ' -f3)

for FILE in $FILES ; do
    cp --parents $FILE ./
done

# Marble data and plugins files

cp -r /usr/$LIB_PATH_ALT/marble/plugins/ ./usr/bin/

cp -r /usr/share/marble/data             ./usr/bin/

# otherwise segfaults!?
cp $(ldconfig -p | grep /usr/$LIB_PATH_ALT/libsasl2.so.2    | cut -d ">" -f 2 | xargs) ./usr/lib/
cp $(ldconfig -p | grep /usr/$LIB_PATH_ALT/libGL.so.1       | cut -d ">" -f 2 | xargs) ./usr/lib/
cp $(ldconfig -p | grep /usr/$LIB_PATH_ALT/libGLU.so.1      | cut -d ">" -f 2 | xargs) ./usr/lib/

# Fedora 23 seemed to be missing SOMETHING from the Centos 6.7. The only message was:
# This application failed to start because it could not find or load the Qt platform plugin "xcb".
# Setting export QT_DEBUG_PLUGINS=1 revealed the cause.
# QLibraryPrivate::loadPlugin failed on "/usr/lib64/qt5/plugins/platforms/libqxcb.so" :
# "Cannot load library /usr/lib64/qt5/plugins/platforms/libqxcb.so: (/lib64/libEGL.so.1: undefined symbol: drmGetNodeTypeFromFd)"
# Which means that we have to copy libEGL.so.1 in too

# Otherwise F23 cannot load the Qt platform plugin "xcb"
cp $(ldconfig -p | grep /usr/$LIB_PATH_ALT/libEGL.so.1      | cut -d ">" -f 2 | xargs) ./usr/lib/

# let's not copy xcb itself, that breaks on dri3 systems https://bugs.kde.org/show_bug.cgi?id=360552
#cp $(ldconfig -p | grep libxcb.so.1 | cut -d ">" -f 2 | xargs) ./usr/lib/

# For Fedora 20
cp $(ldconfig -p | grep /usr/$LIB_PATH_ALT/libfreetype.so.6 | cut -d ">" -f 2 | xargs) ./usr/lib/

cp /usr/bin/digikam     ./usr/bin
cp /usr/bin/showfoto    ./usr/bin

#################################################################################################

echo -e "---------- Scan dependencies recurssively\n"

CopyReccursiveDependencies /usr/bin/digikam                  ./usr/lib
CopyReccursiveDependencies /usr/bin/showfoto                 ./usr/lib
CopyReccursiveDependencies /usr/plugins/platforms/libqxcb.so ./usr/lib

FILES=$(ls /usr/$LIB_PATH_ALT/libdigikam*.so)

for FILE in $FILES ; do
    CopyReccursiveDependencies ${FILE} ./usr/lib
done

FILES=$(ls /usr/plugins/kipiplugin*.so)

for FILE in $FILES ; do
    CopyReccursiveDependencies ${FILE} ./usr/lib
done

#FILES=$(ls /usr/$LIB_PATH_ALT/plugins/imageformats/*.so)
#
#for FILE in $FILES ; do
#    CopyReccursiveDependencies /usr/plugins/imageformats/*.so ./usr/lib
#done

# Copy in the indirect dependencies
FILES=$(find . -type f -executable)

for FILE in $FILES ; do
    CopyReccursiveDependencies ${FILE} ./usr/lib
done

#################################################################################################

echo -e "---------- Clean-up Bundle Directory Contents\n"

# The following are assumed to be part of the base system
rm -f usr/lib/libcom_err.so.2 || true
rm -f usr/lib/libcrypt.so.1 || true
rm -f usr/lib/libdl.so.2 || true
rm -f usr/lib/libexpat.so.1 || true
#rm -f usr/lib/libfontconfig.so.1 || true
rm -f usr/lib/libgcc_s.so.1 || true
rm -f usr/lib/libglib-2.0.so.0 || true
rm -f usr/lib/libgpg-error.so.0 || true
rm -f usr/lib/libgssapi_krb5.so.2 || true
rm -f usr/lib/libgssapi.so.3 || true
rm -f usr/lib/libhcrypto.so.4 || true
rm -f usr/lib/libheimbase.so.1 || true
rm -f usr/lib/libheimntlm.so.0 || true
rm -f usr/lib/libhx509.so.5 || true
rm -f usr/lib/libICE.so.6 || true
rm -f usr/lib/libidn.so.11 || true
rm -f usr/lib/libk5crypto.so.3 || true
rm -f usr/lib/libkeyutils.so.1 || true
rm -f usr/lib/libkrb5.so.26 || true
rm -f usr/lib/libkrb5.so.3 || true
rm -f usr/lib/libkrb5support.so.0 || true
# rm -f usr/lib/liblber-2.4.so.2 || true # needed for debian wheezy
# rm -f usr/lib/libldap_r-2.4.so.2 || true # needed for debian wheezy
rm -f usr/lib/libm.so.6 || true
rm -f usr/lib/libp11-kit.so.0 || true
rm -f usr/lib/libpcre.so.3 || true
rm -f usr/lib/libpthread.so.0 || true
rm -f usr/lib/libresolv.so.2 || true
rm -f usr/lib/libroken.so.18 || true
rm -f usr/lib/librt.so.1 || true
rm -f usr/lib/libsasl2.so.2 || true
rm -f usr/lib/libSM.so.6 || true
rm -f usr/lib/libusb-1.0.so.0 || true
rm -f usr/lib/libuuid.so.1 || true
rm -f usr/lib/libwind.so.0 || true
rm -f usr/lib/libfontconfig.so.* || true

# Remove these libraries, we need to use the system versions; this means 11.04 is not supported (12.04 is our baseline)
rm -f usr/lib/libGL.so.* || true
rm -f usr/lib/libdrm.so.* || true
rm -f usr/lib/libX11.so.* || true
rm -f usr/lib/libz.so.1 || true

# These seem to be available on most systems but not Ubuntu 11.04
# rm -f usr/lib/libffi.so.6 usr/lib/libGL.so.1 usr/lib/libglapi.so.0 usr/lib/libxcb.so.1 usr/lib/libxcb-glx.so.0 || true

# Delete potentially dangerous libraries
rm -f usr/lib/libstdc* usr/lib/libgobject* usr/lib/libc.so.* || true
rm -f usr/lib/libxcb.so.1

# Do NOT delete libX* because otherwise on Ubuntu 11.04:
# loaded library "Xcursor" malloc.c:3096: sYSMALLOc: Assertion (...) Aborted

# We don't bundle the developer stuff
rm -rf usr/include || true
rm -rf usr/lib/cmake3 || true
rm -rf usr/lib/pkgconfig || true
rm -rf usr/share/ECM/ || true
rm -rf usr/share/gettext || true
rm -rf usr/share/pkgconfig || true

#################################################################################################

echo -e "---------- Strip Binaries Files \n"

FILES=$(find . -type f -executable)

for FILE in $FILES ; do
    echo -e "Strip symbols in: $FILE"
    strip ${FILE} 2>/dev/null || true
done

#################################################################################################

echo -e "---------- Strip Configuration Files \n"

# Since we set $APP_IMG_DIR as the prefix, we need to patch it away too (FIXME)
# Probably it would be better to use /app as a prefix because it has the same length for all apps
cd usr/ ; find . -type f -exec sed -i -e 's|$APP_IMG_DIR/usr/|./././././././././|g' {} \; ; cd  ..

# On openSUSE Qt is picking up the wrong libqxcb.so
# (the one from the system when in fact it should use the bundled one) - is this a Qt bug?
# Also, Krita has a hardcoded /usr which we patch away
cd usr/ ; find . -type f -exec sed -i -e 's|/usr|././|g' {} \; ; cd ..

# We do not bundle this, so let's not search that inside the AppImage. 
# Fixes "Qt: Failed to create XKB context!" and lets us enter text
sed -i -e 's|././/share/X11/|/usr/share/X11/|g' ./usr/plugins/platforminputcontexts/libcomposeplatforminputcontextplugin.so
sed -i -e 's|././/share/X11/|/usr/share/X11/|g' ./usr/lib/libQt5XcbQpa.so.5

# Workaround for:
# D-Bus library appears to be incorrectly set up;
# failed to read machine uuid: Failed to open
# The file is more commonly in /etc/machine-id
# sed -i -e 's|/var/lib/dbus/machine-id|//././././etc/machine-id|g' ./usr/lib/libdbus-1.so.3
# or
rm -f ./usr/lib/libdbus-1.so.3 || true

cd /

#################################################################################################

APP=digikam

if [[ "$ARCH" = "x86_64" ]] ; then
    APPIMAGE=$APP"-"$DK_RELEASEID"-x86-64"$DK_EPOCH".appimage"
elif [[ "$ARCH" = "i686" ]] ; then
    APPIMAGE=$APP"-"$DK_RELEASEID"-i386"$DK_EPOCH".appimage"
fi

if [[ $APPIMAGE_VERSION -eq 1 ]] ; then

    echo -e "---------- Create Bundle with AppImage SDK V1\n"

    # Source functions
    wget -q https://github.com/probonopd/AppImages/raw/master/functions.sh -O ./functions.sh
    . ./functions.sh

    # Install desktopintegration in usr/bin/digikam.wrapper
    cd $APP_IMG_DIR

    # We will use a dedicated bash script to run inside the AppImage to be sure that XDG_* variable are set for Qt5
    cp ${ORIG_WD}/data/AppRun .

    # desktop integration rules
    cp /usr/share/applications/org.kde.digikam.desktop digikam.desktop
    cp /usr/share/icons/hicolor/64x64/apps/digikam.png digikam.png
    get_desktopintegration digikam

    cd /

    mkdir -p $ORIG_WD/appimage
    rm -f $ORIG_WD/appimage/* || true
    AppImageKit/AppImageAssistant.AppDir/package $APP_IMG_DIR/ $ORIG_WD/appimage/$APPIMAGE

    chmod a+rwx $ORIG_WD/appimage/$APPIMAGE

elif [[ $APPIMAGE_VERSION -eq 2 ]] ; then

    echo -e "---------- Create Bundle with AppImage SDK V2\n"

    # TODO

else

    echo -e "Unknown AppImage SDK version!"
    exit

fi

#################################################################################################
# Show resume information and future instructions to host installer file to KDE server

echo -e "\n---------- Compute package checksums for digiKam $DK_RELEASEID\n"    > $ORIG_WD/appimage/$APPIMAGE.txt
echo    "File       : $APPIMAGE"                                               >> $ORIG_WD/appimage/$APPIMAGE.txt
echo -n "Size       : "                                                        >> $ORIG_WD/appimage/$APPIMAGE.txt
du -h "$ORIG_WD/appimage/$APPIMAGE"     | { read first rest ; echo $first ; }  >> $ORIG_WD/appimage/$APPIMAGE.txt
echo -n "MD5 sum    : "                                                        >> $ORIG_WD/appimage/$APPIMAGE.txt
md5sum "$ORIG_WD/appimage/$APPIMAGE"    | { read first rest ; echo $first ; }  >> $ORIG_WD/appimage/$APPIMAGE.txt
echo -n "SHA1 sum   : "                                                        >> $ORIG_WD/appimage/$APPIMAGE.txt
sha1sum "$ORIG_WD/appimage/$APPIMAGE"   | { read first rest ; echo $first ; }  >> $ORIG_WD/appimage/$APPIMAGE.txt
echo -n "SHA256 sum : "                                                        >> $ORIG_WD/appimage/$APPIMAGE.txt
sha256sum "$ORIG_WD/appimage/$APPIMAGE" | { read first rest ; echo $first ; }  >> $ORIG_WD/appimage/$APPIMAGE.txt

cat $ORIG_WD/appimage/$APPIMAGE.txt
echo -e "\n------------------------------------------------------------------"
curl http://download.kde.org/README_UPLOAD
echo -e "------------------------------------------------------------------\n"

#################################################################################################

TerminateScript

