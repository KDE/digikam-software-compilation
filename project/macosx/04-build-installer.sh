#! /bin/bash

# Script to bundle data using previously-built KDE and digiKam installation.
# and create a PKG file with Packages application (http://s.sudre.free.fr/Software/Packages/about.html)
# This script must be run as sudo
#
# Copyright (c) 2015,      Shanti, <listaccount at revenant dot org>
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

echo "04-build-installer.sh : build digiKam bundle PKG."
echo "-------------------------------------------------"

#################################################################################################
# Pre-processing checks

. ./config.sh
. ./common.sh
StartScript
ChecksRunAsRoot
OsxCodeName

#################################################################################################

# Pathes rules
ORIG_PATH="$PATH"
ORIG_WD="`pwd`"

export PATH=$INSTALL_PREFIX/bin:/$INSTALL_PREFIX/sbin:$ORIG_PATH

DKRELEASEID=`cat $ORIG_WD/data/RELEASEID.txt`

#################################################################################################
# Build icons-set ressource

echo -e "\n---------- Build icons-set ressource\n"

cd $ORIG_WD/icon-rcc

cp -f $ORIG_WD/../../bootstrap.macports .

cmake -DCMAKE_INSTALL_PREFIX="$INSTALL_PREFIX" \
      -DCMAKE_BUILD_TYPE=debug \
      -DCMAKE_COLOR_MAKEFILE=ON \
      -Wno-dev \
      .

make -j$CPU_CORES

cd $ORIG_WD

#################################################################################################
# Configurations

# Directory where this script is located (default - current directory)
BUILDDIR="$PWD"

# Directory where Packages project files are located
PROJECTDIR="$BUILDDIR/installer"

# Staging area where files to be packaged will be copied
TEMPROOT="$BUILDDIR/$INSTALL_PREFIX"

# KDE apps to be launched directly by user (create launch scripts)
KDE_MENU_APPS="\
digikam \
showfoto \
"

# Paths to search for KDE applications above
KDE_APP_PATHS="\
Applications/KF5 \
"

# Other apps - non-MacOS binaries & libraries to be included with required dylibs
OTHER_APPS="\
Applications/KF5/digikam.app/Contents/MacOS/digikam \
Applications/KF5/showfoto.app/Contents/MacOS/showfoto \
lib/plugins/*.so \
bin/kbuildsycoca5 \
libexec/qt5/plugins/imageformats/*.dylib \
libexec/qt5/plugins/sqldrivers/*.dylib \
libexec/qt5/plugins/printsupport/*.dylib \
libexec/qt5/plugins/platforms/*.dylib \
libexec/qt5/plugins/mediaservice/*.dylib \
libexec/qt5/plugins/iconengines/*.dylib \
libexec/qt5/plugins/audio/*.dylib \
libexec/qt5/plugins/position/*.dylib \
libexec/qt5/plugins/geoservices/*.dylib \
"

binaries="$OTHER_APPS"

# Additional Files/Directories - to be copied recursively but not checked for dependencies
OTHER_DIRS="\
lib/plugins \
"

#lib/sane \

# Additional Data Directories - to be copied recursively
OTHER_DATA="\
etc/xdg \
share/applications \
share/OpenCV \
share/k* \
share/lensfun \
share/locale/ \
share/mime \
Library/Application/ \
Marble.app/Contents/Resources/ \
Marble.app/Contents/MacOS/resources/ \
"

#etc/sane.d \

# Packaging tool paths
PACKAGESUTIL="/usr/local/bin/packagesutil"
PACKAGESBUILD="/usr/local/bin/packagesbuild"
RECURSIVE_LIBRARY_LISTER="$BUILDDIR/rll.py"

echo -n "digiKam version: $DKRELEASEID"

# digiKam has been built with debug symbol. We'll need to set DYLIB_IMAGE_SUFFIX later.
DEBUG=1

# ./installer sub-dir must be writable by root
chmod 777 ${PROJECTDIR}

#################################################################################################
# Check if Packages CLI tools are installed

if [[ (! -f "$PACKAGESUTIL") && (! -f "$PACKAGESBUILD") ]] ; then
        echo "Packages CLI tools are not installed"
        echo "See http://s.sudre.free.fr/Software/Packages/about.html for details."
        exit 1
else
        echo "Check Packages CLI tools passed..."
fi

#################################################################################################
# Create temporary dir to build package contents

if [ -d "$TEMPROOT" ] ; then
        echo "---------- Removing temporary packaging directory $TEMPROOT"
        rm -rf "$TEMPROOT"
fi

echo "Creating $TEMPROOT"
mkdir -p "$TEMPROOT/Applications/digiKam"

#################################################################################################
# Prepare KDE applications for OSX

echo "---------- Preparing KDE Applications"

for app in $KDE_MENU_APPS ; do
    echo "  $app"

    # Look for application

    for searchpath in $KDE_APP_PATHS ; do

        # Copy the application if it is found (create directory if necessary)

        if [ -d "$INSTALL_PREFIX/$searchpath/$app.app" ] ; then
            echo "    Found $app in $INSTALL_PATH/$searchpath"

        # Create destination directory if necessary and copy app

        if [ ! -d "$TEMPROOT/$searchpath" ] ; then 
            echo "    Creating $TEMPROOT/$searchpath"
            mkdir -p "$TEMPROOT/$searchpath"
        fi

        echo "    Copying $app"
        cp -pr "$INSTALL_PREFIX/$searchpath/$app.app" "$TEMPROOT/$searchpath/"

        # Add executable to list of binaries for which we need to collect dependencies for

        binaries="$binaries $searchpath/$app.app/Contents/MacOS/$app"

        # If application is to be run by user, create Applescript launcher to
        # load dbus-session if necessary, launch kded4, set DYLD_IMAGE_SUFFIX
        # if built with debug variant

        if [[ $KDE_MENU_APPS == *"$app"* ]] ; then
            echo "    Creating launcher script for $app"

            # Debug variant needs DYLD_IMAGE_SUFFIX="_debug set at runtime

            if [ $DEBUG ] ; then
                DYLD_ENV_CMD="DYLD_IMAGE_SUFFIX=_debug "
            else
                DYLD_ENV_CMD=""
            fi

            # ------ Create KDE application launcher script
            # Partially derived from https://discussions.apple.com/thread/3934912 and
            # http://stackoverflow.com/questions/16064957/how-to-check-in-applescript-if-an-app-is-running-without-launching-it-via-osa
            # and https://discussions.apple.com/thread/4059113

            cat << EOF | osacompile -o "$TEMPROOT/Applications/digiKam/$app.app"
#!/usr/bin/osascript

log "Running $DYLD_ENV_CMD $INSTALL_PREFIX/bin/kbuildsycoca5"
do shell script "$DYLD_ENV_CMD $INSTALL_PREFIX/bin/kbuildsycoca5"

do shell script "$DYLD_ENV_CMD open $INSTALL_PREFIX/$searchpath/$app.app --args --graphicssystem=native"
EOF
                # ------ End KDE application launcher script

                # Get application icon for launcher. If no icon file matches pattern app_SRCS.icns, grab the first icon

                if [ -f "$INSTALL_PREFIX/$searchpath/$app.app/Contents/Resources/${app}_SRCS.icns" ] ; then
                    echo "    Found icon for $app launcher"
                    cp -p "$INSTALL_PREFIX/$searchpath/$app.app/Contents/Resources/${app}_SRCS.icns" "$TEMPROOT/Applications/digiKam/$app.app/Contents/Resources/applet.icns"
                else
                    for icon in "$INSTALL_PREFIX/$searchpath/$app.app/"Contents/Resources/*.icns ; do
                        echo "    Using icon for $app launcher: $icon"
                        cp -p "$icon" "$TEMPROOT/Applications/digiKam/$app.app/Contents/Resources/applet.icns"
                        break
                    done
                fi

                chmod 755 "$TEMPROOT/Applications/digiKam/$app.app"
            fi

            # Don't keep looking through search paths once we've found the app
            break
        fi

    done

done

#################################################################################################
# Collect dylib dependencies for all KDE and other binaries,
# then copy them to the staging area (creating directories as required)

echo "---------- Collecting dependencies for applications, binaries, and libraries:"

cd "$INSTALL_PREFIX"

"$RECURSIVE_LIBRARY_LISTER" $binaries | sort -u | \
while read lib ; do
    lib="`echo $lib | sed "s:$INSTALL_PREFIX/::"`"

    if [ ! -e "$TEMPROOT/$lib" ] ; then
        dir="${lib%/*}"

        if [ ! -d "$TEMPROOT/$dir" ] ; then
            echo "  Creating $TEMPROOT/$dir"
            mkdir -p "$TEMPROOT/$dir"
        fi

        echo "  $lib"
        cp -aH "$INSTALL_PREFIX/$lib" "$TEMPROOT/$dir/"
    fi
done

#################################################################################################
# Copy non-binary files and directories, creating parent directories if needed

echo "---------- Copying non-binary files and directories..."

for path in $OTHER_APPS $OTHER_DIRS ; do
    dir="${path%/*}"

    if [ ! -d "$TEMPROOT/$dir" ] ; then
        echo "  Creating $TEMPROOT/$dir"
        mkdir -p "$TEMPROOT/$dir"
    fi

    echo "  $path"
    cp -a "$INSTALL_PREFIX/$path" "$TEMPROOT/$dir/"
done

# Special case with data dirs. QStandardPaths::GenericDataLocation was patched everywhere
# in source code by QStandardPaths::AppDataLocation 
for path in $OTHER_DATA ; do
    cp -a "$INSTALL_PREFIX/$path" "$TEMPROOT/Applications/KF5/digikam.app/Contents/Resources/"
done

# Showfoto resources dir will be merged with digiKam. A symbolic link to digiKam resources dir will be used for Showfoto
cp -a "$TEMPROOT/Applications/KF5/showfoto.app/Contents/Resources/" "$TEMPROOT/Applications/KF5/digikam.app/Contents/Resources/"
rm -rf "$TEMPROOT/Applications/KF5/showfoto.app/Contents/Resources"
ln -s "$TEMPROOT/Applications/KF5/digikam.app/Contents/Resources" "$TEMPROOT/Applications/KF5/showfoto.app/Contents/Resources"

cd "$ORIG_WD"

#################################################################################################
# Move KF5 run-time plugins to the right place

find  $TEMPROOT/lib/plugins -name "*.so" -type f -maxdepth 1 -exec mv {} $TEMPROOT/libexec/qt5/plugins/ \;
rm -rf $TEMPROOT/lib/plugins

#################################################################################################
# Set KDE default applications settings for OSX

echo "---------- Creating KDE global config for OSX"

if [ ! -d "$TEMPROOT/Applications/KF5/digikam.app/Contents/Resources/config" ] ; then
    echo "---------- $TEMPROOT/Applications/KF5/digikam.app/Contents/Resources/config do not exist, creating"

    mkdir "$TEMPROOT/Applications/KF5/digikam.app/Contents/Resources/config"

    if [ $? -ne 0 ] ; then
        echo "---------- Cannot create $TEMPROOT/Applications/KF5/digikam.app/Contents/Resources/config directory."
        echo "---------- Aborting..."
        exit;
    fi
fi

cat << EOF > "$TEMPROOT/Applications/KF5/digikam.app/Contents/Resources/config/kdeglobals"
[General]
BrowserApplication[\$e]=!/usr/bin/open /Applications/Safari.app
TerminalApplication[\$e]=!/usr/bin/open /Applications/Utilities/Terminal.app
EmailClient[\$e]=!/usr/bin/open /Applications/Mail.app
EOF

#################################################################################################
# Create package pre-install script

echo "---------- Create package pre-install script"

# Unload dbus-system, delete /Applications entries, delete existing installation

cat << EOF > "$PROJECTDIR/preinstall"
#!/bin/bash

if [ -d /Applications/digiKam ] ; then
    echo "Removing digikam from Applications folder"
    rm -r /Applications/digiKam
fi

if [ -d "$INSTALL_PREFIX" ] ; then
    echo "Removing $INSTALL_PREFIX"
    rm -rf "$INSTALL_PREFIX"
fi
EOF

# Pre-install script need to be executable

chmod 755 "$PROJECTDIR/preinstall"

#################################################################################################
# Create package post-install script

echo "---------- Create package post-install script"

# Loads dbus-system and creates Applications menu icons

cat << EOF > "$PROJECTDIR/postinstall"
#!/bin/bash

[[ ! -d /Applications/digiKam ]] && mkdir "/Applications/digiKam"

for app in $INSTALL_PREFIX/Applications/digiKam/*.app ; do
    ln -s "\$app" /Applications/digiKam/\${app##*/}
done
EOF

# Post-install script need to be executable

chmod 755 "$PROJECTDIR/postinstall"

#################################################################################################
# Copy icons-set resource file

cp $ORIG_WD/icon-rcc/breeze.rcc $TEMPROOT/Applications/KF5/digikam.app/Contents/Resources/

#################################################################################################
# Build PKG file

echo "---------- Create OSX package for digiKam $DKRELEASEID"

TARGET_PKG_FILE=$BUILDDIR/digikam-$DKRELEASEID-osx.pkg
echo -e "Target PKG file : $TARGET_PKG_FILE"

$PACKAGESUTIL --file "$PROJECTDIR/digikam.pkgproj" \
    set version "$DKRELEASEID"

$PACKAGESBUILD -v "$PROJECTDIR/digikam.pkgproj"

mv "$PROJECTDIR/build/digikam.pkg" "$TARGET_PKG_FILE"

#################################################################################################
# Show resume information and future instructions to host PKG file to KDE server

echo -e "\n---------- Compute package checksums for digiKam $DKRELEASEID\n"

echo    "File       : $TARGET_PKG_FILE"
echo -n "Size       : "
du -h "$TARGET_PKG_FILE"        | { read first rest ; echo $first ; }
echo -n "MD5 sum    : "
md5 -q "$TARGET_PKG_FILE"
echo -n "SHA1 sum   : "
shasum -a1 "$TARGET_PKG_FILE"   | { read first rest ; echo $first ; }
echo -n "SHA256 sum : "
shasum -a256 "$TARGET_PKG_FILE" | { read first rest ; echo $first ; }

echo -e "\n------------------------------------------------------------------"
curl http://download.kde.org/README_UPLOAD
echo -e "------------------------------------------------------------------\n"

#################################################################################################

export PATH=$ORIG_PATH

TerminateScript
