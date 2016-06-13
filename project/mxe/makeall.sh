#!/bin/bash

# Script to run all MXE based sub-scripts to build Windows installer.
# Possible option : "-f" to force operations without to ask confirmation to user.
#
# Copyright (c) 2013-2016, Gilles Caulier, <caulier dot gilles at gmail dot com>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.
#

# halt on error
set -e

. ./config.sh
StartScript

echo "This script will build from scratch the digiKam installer for Windows using MXE."
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

if [ -d "$MXE_BUILDROOT" ] ; then

    if [ $1 -ne "-f" ]

        read -p "A previous MXE build already exist and it will be removed. Do you want to continue ? [(c)ontinue/(s)top] " answer

        if echo "$answer" | grep -iq "^s" ; then

            echo "---------- Aborting..."
            exit;

        fi

    fi

    echo "---------- Removing existing MXE build"
    chmod +w "$MXE_BUILDROOT/usr/readonly"
    chattr -i "$MXE_BUILDROOT/usr/readonly/.gitkeep"
    rm -fr $MXE_BUILDROOT

fi

./01-build-mxe.sh
./02-build-extralibs.sh
./03-build-digikam.sh
./04-build-installer.sh

echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

TerminateScript
