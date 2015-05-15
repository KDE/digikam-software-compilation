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

# Pre-processing checks
. ../common/common.sh
ChecksRunAsRoot
ChecksXCodeCLI

#################################################################################################"

# Directory where MacPorts will be built, and where it will be installed by packaging script
INSTALL_PREFIX="/opt/digikam"

# Macports tarball information
MP_URL="https://distfiles.macports.org/MacPorts/"
MP_VERSION="2.3.3"
MP_BUILDTEMP=~/mptemp

# Pathes rules
ORIG_PATH="$PATH"
ORIG_WD="`pwd`"

#################################################################################################"
# Target directory creation
echo -e "\n\n"

# Delete and re-create target install directory
if [ -d "$INSTALL_PREFIX" ] ; then

    read -p "$INSTALL_PREFIX already exist and will be removed. Do you want to continue?" answer
    if echo "$answer" | grep -iq "^y" ;then
        echo "---------- Removing existing $INSTALL_PREFIX"
        rm -rf "$INSTALL_PREFIX"
    else
        echo "---------- Aborting..."
        exit;
    fi

fi

echo "---------- Creating $INSTALL_PREFIX"
mkdir "$INSTALL_PREFIX"

#################################################################################################"
# Build Macports in temporary directory and installation

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

echo "---------- Building MacPorts"
make
echo -e "\n\n"

echo "---------- Installing MacPorts"
echo -e "\n\n"
make install && cd "$ORIG_WD" && rm -rf "$MP_BUILDTEMP"

cat << EOF >> "$INSTALL_PREFIX/etc/macports/macports.conf"
+no_root -startupitem
startupitem_type none
startupitem_install no
EOF

#################################################################################################"
# Macports update

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

#################################################################################################"
# Dependencies build and installation

echo "*** Building digikam dependencies with Macports"

InstallCorePackages

# External MySQL external database support.
# By default akonadi variant (mariadb55) breaks build due to conflict with mysql5x
#port install akonadi +mysql56 digikam +docs+mysql56_external+debug

#################################################################################################"
# digiKam build and installation

port install digikam +docs+lcms2+translations

#################################################################################################"

export PATH=$ORIG_PATH
