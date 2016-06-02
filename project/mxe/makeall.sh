#!/bin/sh

# Copyright (c) 2013-2016, Gilles Caulier, <caulier dot gilles at gmail dot com>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.

. ./config.sh
StartScript

# halt on error
set -e

echo "This script will build from scratch the digiKam installer for Windows using MXE."
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

if [ -d "$MXE_BUILDROOT" ] ; then

    read -p "A previous MXE build already exist and it will be removed. Do you want to continue ? [(c)ontinue/(s)top] " answer

    if echo "$answer" | grep -iq "^c" ;then

        echo "---------- Removing existing MXE build"
        chmod +w "$MXE_BUILDROOT/usr/readonly"
        chattr -i "$MXE_BUILDROOT/usr/readonly/.gitkeep"
        rm -fr $MXE_BUILDROOT

    else

        echo "---------- Aborting..."
        exit;

    fi

fi

./01-build-mxe.sh
./02-build-extralibs.sh
./03-build-digikam.sh
./04-build-installer.sh

echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

TerminateScript
