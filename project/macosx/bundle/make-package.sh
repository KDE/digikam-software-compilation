#! /bin/bash

# Script to prepare previously-built KDE and digiKam installation through build-digikam.sh
# and package it using Packages application (http://s.sudre.free.fr/Software/Packages/about.html)
# This script must be run as sudo
#
# Copyright (c) 2015, Shanti, <listaccount at revenant dot org>
# Copyright (c) 2015, Gilles Caulier, <caulier dot gilles at gmail dot com>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.
#

# MacPorts install directory (and location where packaged files will be)
INSTALL_PREFIX="/opt/digikam"

# Directory where this script is located (default - current directory)
BUILDDIR="$PWD"

# Directory where Packages project files are located
PROJECTDIR="$BUILDDIR/package"

# Staging area where files to be packaged will be copied
TEMPROOT="$BUILDDIR/opt/digikam"

# KDE apps to be launched directly by user (create launch scripts)
KDE_MENU_APPS="\
digikam \
dngconverter \
panoramagui \
showfoto \
systemsettings \
"

# KDE apps to be included but not launched directly by user
KDE_OTHER_APPS="\
kcmshell4 \
kded4 \
kdeinit4 \
kdialog \
kdebugdialog \
khelpcenter \
knotify4 \
scangui \
drkonqi \
"

# Paths to search for KDE applications above
KDE_APP_PATHS="\
Applications/KDE4 \
lib/kde4/libexec \
"
# Other apps - non-MacOS binaries & libraries to be included with required dylibs
OTHER_APPS="\
bin/dbus-daemon \
bin/dbus-launch \
bin/kbuildsycoca4 \
libexec/dbus-daemon-launch-helper \
lib/kde4/kipiplugin*.so \
lib/kde4/digikamimageplugin*.so \
lib/kde4/kcm_*.so \
lib/kde4/kio_digikam*.so \
lib/kde4/libexec/klauncher \
lib/kde4/libexec/lnusertemp \
share/qt4/plugins/designer/libphononwidgets.dylib \
share/qt4/plugins/imageformats/*.dylib \
share/qt4/plugins/sqldrivers/*.dylib \
"
binaries="$OTHER_APPS"

# Additional Files/Directories - to be copied recursively but not checked for dependencies
OTHER_DIRS="\
Library/LaunchAgents/org.freedesktop.dbus-session.plist \
Library/LaunchDaemons/org.freedesktop.dbus-system.plist \
etc/dbus-1 \
etc/xdg/menus \
lib/kde4 \
share/applications/kde4 \
share/apps \
share/config \
share/dbus-1 \
share/doc/HTML/en/digikam \
share/doc/HTML/en/showfoto \
share/icons/hicolor \
share/icons/oxygen \
share/kde4 \
share/qt4/plugins/designer/libphononwidgets.dylib \
share/qt4/plugins/imageformats \
share/qt4/plugins/sqldrivers \
share/lensfun \
share/locale/currency/usd.desktop \
share/locale/en_US \
share/mime \
var/run/dbus \
"

PACKAGESUTIL="/usr/local/bin/packagesutil"
PACKAGESBUILD="/usr/local/bin/packagesbuild"
RECURSIVE_LIBRARY_LISTER="$BUILDDIR/rll.py"

# If the port command isn't in install prefix/bin, $INSTALL_PREFIX is probably wrong
if [ ! -f "$INSTALL_PREFIX/bin/port" ] ; then 
  echo "$INSTALL_PREFIX/bin/port not found"
  exit
fi

# Make sure digikam is installed, and figure out what version
echo -n "Determining digikam version: "
DIGIKAM_VERSION="`$INSTALL_PREFIX/bin/port -q installed digikam | sed "s/^.*@//;s/ (.*)//"`"
[[ ! "$DIGIKAM_VERSION" ]] && echo "digikam port not installed" && exit
echo $DIGIKAM_VERSION

# Is the debug variant installed (we'll need to set DYLIB_IMAGE_SUFFIX later)
if [[ $DIGIKAM_VERSION == *"+debug"* ]] ; then
  echo "Debug variant found"
  DEBUG=1
else
  DEBUG=0
fi

# ./package sub-dir must be writable by root
chmod 777 ${PROJECTDIR}

ORIG_WD="`pwd`"

if [ -d "$TEMPROOT" ] ; then
  echo "Removing temporary packaging directory $TEMPROOT"
  rm -rf "$TEMPROOT"
fi

echo "Creating $TEMPROOT"
mkdir -p "$TEMPROOT/Applications/digiKam"

echo "Preparing KDE Applications"
for app in $KDE_MENU_APPS $KDE_OTHER_APPS ; do
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
        cat << EOF | osacompile -o "$TEMPROOT/Applications/digiKam/$app.app"

#!/usr/bin/osascript
#Partially derived from https://discussions.apple.com/thread/3934912

on checkService(service)
	do shell script "launchctl list"
	if the result contains service then
		return true
	else
		return false
	end if
end checkService

on checkProcess(process)
	tell app "System Events" to set processRunning to exists (processes whose name is "process")
	return ProcessRunning
end checkProcess

if not checkService("org.freedesktop.dbus-session") then
	log "Running launchctl load -w $INSTALL_PREFIX/Library/LaunchAgents/org.freedesktop.dbus-session.plist"
	do shell script "launchctl load -w $INSTALL_PREFIX/Library/LaunchAgents/org.freedesktop.dbus-session.plist"
	log "Running $DYLD_ENV_CMD $INSTALL_PREFIX/bin/kbuildsycoca4"
	do shell script "$DYLD_ENV_CMD $INSTALL_PREFIX/bin/kbuildsycoca4"
end if

if not checkProcess("kded4")
	do shell script "$DYLD_ENV_CMD $INSTALL_PREFIX/Applications/KDE4/kded4.app/Contents/MacOS/kded4 &> /dev/null &"
end if

do shell script "$DYLD_ENV_CMD open $INSTALL_PREFIX/$searchpath/$app.app"
EOF
# ------ End KDE application launcher script

        # Get application icon for launcher. If no icon file matchesl pattern 
        # app_SRCS.icns (e.g. panoramagui), grab the first icon
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

# Collect dylib dependencies for all KDE and other binaries, then copy them
# to the staging area (creating directories as required)
echo "Collecting dependencies for applications, binaries, and libraries:"

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

# Copy non-binary files and directories, creating parent directories if needed
echo "Copying non-binary files and directories..."
for path in $OTHER_APPS $OTHER_DIRS ; do
  dir="${path%/*}"
  if [ ! -d "$TEMPROOT/$dir" ] ; then
    echo "  Creating $TEMPROOT/$dir"
    mkdir -p "$TEMPROOT/$dir"
  fi
  echo "  $path"
  cp -a "$INSTALL_PREFIX/$path" "$TEMPROOT/$dir/"
done

cd "$ORIG_WD"

[[ -e "$TEMPROOT/var/run/dbus/.turd_dbus" ]] && rm -v "$TEMPROOT/var/run/dbus/.turd_dbus"

# Set KDE default applications to OSX paths
echo "Creating $TEMPROOT/share/config/kdeglobals"
cat << EOF > "$TEMPROOT/share/config/kdeglobals"
[General]
BrowserApplication[\$e]=!/usr/bin/open /Applications/Safari.app
TerminalApplication[\$e]=!/usr/bin/open /Applications/Utilities/Terminal.app
EmailClient[\$e]=!/usr/bin/open /Applications/Mail.app
EOF

# Delete dbus system config lines pertaining to running as non-root user
# (installed version will be run as root, although MacPorts version wasn't)
echo "Deleting dbus system config lines pertaining to running as non-root user"
sed -i "" '/<!-- Run as special user -->/{N;N;d;}' $TEMPROOT/etc/dbus-1/system.conf

# Create package preinstall script
# Unload dbus-system, delete /Applications entries, delete existing
# installation
cat << EOF > "$PROJECTDIR/preinstall"
#!/bin/bash
# Generated (and will be overwritten by) make-package.sh

if [ \`launchctl list | grep -c org.freedesktop.dbus-system\` -gt 0 ] ; then
  echo "Unloading dbus-system"
  launchctl unload "$INSTALL_PREFIX/Library/LaunchDaemons/org.freedesktop.dbus-system"
fi

if [ -d /Applications/digiKam ] ; then
  echo "Removing digikam from Applications folder"
  rm -r /Applications/digiKam
fi

if [ -d "$INSTALL_PREFIX" ] ; then
  echo "Removing $INSTALL_PREFIX"
  rm -rf "$INSTALL_PREFIX"
fi
EOF

# Create package postinstall script
# Loads dbus-system and creates Applications menu icons
cat << EOF > "$PROJECTDIR/postinstall"
#!/bin/bash
# Generated (and will be overwritten) by make-package.sh

launchctl load -w "$INSTALL_PREFIX/Library/LaunchDaemons/org.freedesktop.dbus-system.plist"

[[ ! -d /Applications/digiKam ]] && mkdir "/Applications/digiKam"

for app in $INSTALL_PREFIX/Applications/digiKam/*.app ; do
  ln -s "\$app" /Applications/digiKam/\${app##*/}
done
EOF

# Preinstall and postinstall need to be executable
chmod 755 "$PROJECTDIR/preinstall" "$PROJECTDIR/postinstall"

# Build PKG file
echo Preparing to create package for digikam $DIGIKAM_VERSION
$PACKAGESUTIL --file "$PROJECTDIR/digikam.pkgproj" \
   set version "$DIGIKAM_VERSION"

$PACKAGESBUILD -v "$PROJECTDIR/digikam.pkgproj"

mv "$PROJECTDIR/build/digikam.pkg" "$BUILDDIR/digikam-$DIGIKAM_VERSION.pkg"

#Build Checksum files of package
echo Compute package checksums for digikam $DIGIKAM_VERSION
shasum -a1 "$BUILDDIR/digikam-$DIGIKAM_VERSION.pkg"
shasum -a256 "$BUILDDIR/digikam-$DIGIKAM_VERSION.pkg"
md5 "$BUILDDIR/digikam-$DIGIKAM_VERSION.pkg"

echo To upload digiKam PKG file, follow instructions to http://download.kde.org/README_UPLOAD
