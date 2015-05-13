#! /bin/bash

# Script to build digiKam using MacPorts
# This script must be run as sudo
#
# Copyright (c) 2015, Shanti, <listaccount at revenant dot org>
# Copyright (c) 2015, Gilles Caulier, <caulier dot gilles at gmail dot com>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.
#

# Directiory where MacPorts will be built, and where it will be installed by
# packaging script
INSTALL_PREFIX="/opt/digikam"

# Temporary directory in which MacPorts will be built
MP_BUILDTEMP=~/mptemp

MP_URL="https://distfiles.macports.org/MacPorts/"
MP_VERSION="2.3.3"

ORIG_PATH="$PATH"
ORIG_WD="`pwd`"

echo -e "\n\n"

# Delete and re-create MacPorts install directory
if [ -d "$INSTALL_PREFIX" ] ; then
   echo "---------- Removing existing  $INSTALL_PREFIX"
   rm -rf "$INSTALL_PREFIX"
fi

echo "---------- Creating $INSTALL_PREFIX"
mkdir "$INSTALL_PREFIX"

# Delete and re-create temporary MacPorts build directory
if [ -d "$MP_BUILDTEMP" ] ; then
   echo "---------- Removing existing $MP_BUILDTEMP" 
   rm -rf "$MP_BUILDTEMP"
fi

echo "---------- Creating $MP_BUILDTEMP"
mkdir "$MP_BUILDTEMP"

cd "$MP_BUILDTEMP"
echo -e "\n\n"

echo "---------- Downloading MacPorts $MP_VERSION"
curl -o "MacPorts-$MP_VERSION.tar.bz2" "$MP_URL/MacPorts-$MP_VERSION.tar.bz2"
tar jxvf MacPorts-$MP_VERSION.tar.bz2
cd MacPorts-$MP_VERSION
echo -e "\n\n"

echo "---------- Configuring MacPorts"
./configure --prefix="$INSTALL_PREFIX" \
	    --with-applications-dir="$INSTALL_PREFIX/Applications" \
	    --with-no-root-privileges \
	    --with-install-user="$(id -n -u)" \
	    --with-install-group="$(id -n -g)" 
echo -e "\n\n"

echo *** Building MacPorts
make 
echo -e "\n\n"

echo *** Installing MacPorts
echo -e "\n\n"
make install && cd "$ORIG_WD" && rm -rf "$MP_BUILDTEMP"

cat << EOF >> "$INSTALL_PREFIX/etc/macports/macports.conf"
+no_root -startupitem
startupitem_type none
startupitem_install no
EOF

export PATH=$INSTALL_PREFIX/bin:/$INSTALL_PREFIX/sbin:$ORIG_PATH

echo -e "\n"
echo "---------- Updating MacPorts"
port -v selfupdate
echo -e "\n"

#echo "---------- Modifying net-snmp portfile to install when not root"
#sed -e "/install.asroot/ s|yes|no|" -i ".orig" "`port file net-snmp`"

# Remove kdelibs avahi dependency  (https://bugs.kde.org/show_bug.cgi?id=257679)
#echo "---------- Removing Avahi depenency from kdelibs4"
#sed -e "s/port:avahi *//" -e "s/-DWITH_Avahi=ON/-DWITH_Avahi=OFF/" -i ".orig-avahi" "`port file kdelibs4`"

# Use custom digikam portfile if digikam-portfile/Portfile exists
#[[ -f digikam-portfile/Portfile ]] && echo "*** Replacing digikam portfile with digikam-portfile/Portfile" && cp digikam-portfile/Portfile "`port file digikam`"

echo "*** Building digikam with Macports"

# Manual install of texlive-fonts-recommended & texlive-font-utils is
# required  to build docs
port install texlive-fonts-recommended texlive-fontutils

# Install Macports packages to compile digiKam
# See https://trac.macports.org/wiki/KDE for details

port install qt4-mac
port install qt4-mac-sqlite3-plugin 
port install kdelibs4
port install kde4-baseapps
port install opencv
port install marble
port install oxygen-icons
port install sane-backends
port install libgpod
port install libgphoto2
port install lensfun
port install liblqr
port install libraw
port install eigen3
port install sqlite2
port install baloo

# For Color themes support

port install kdeartwork

# For Acqua style support

port install kde4-workspace
port install qtcurve

# For video support

port install kdemultimedia4
port install ffmpegthumbs

# External MySQL external database support is why I use digikam. Default
# akonadi variant (mariadb55) breaks build due to conflict with mysql5x
#port install akonadi +mysql56 digikam +docs+mysql56_external+debug

port install digikam +docs+lcms2+translations

export PATH=$ORIG_PATH
