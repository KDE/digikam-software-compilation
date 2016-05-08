#! /bin/bash

# Script to build a bundle Mxe installation with all digiKam dependencies in a dedicated directory
#
# Copyright (c) 2015-2016, Gilles Caulier, <caulier dot gilles at gmail dot com>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.
#

#################################################################################################
# Manage script traces to log file

exec > >(tee build-mxe.full.log) 2>&1

#################################################################################################

echo "01-build-mxe.sh : build a bundle Mxe install with digiKam dependencies."
echo "-----------------------------------------------------------------------"

#################################################################################################
# Pre-processing checks

. ./configbundlemxe.sh
. ./common.sh
StartScript

#################################################################################################

# Pathes rules
ORIG_PATH="$PATH"
ORIG_WD="`pwd`"

#################################################################################################
# Check if a previous bundle already exist

CONTINUE_INSTALL=0

if [ -d "$MXE_BUILDROOT" ] ; then

    read -p "$MXE_BUILDROOT already exist. Do you want to remove it or to continue an aborted previous installation ? [(r)emove/(c)ontinue/(s)top] " answer

    if echo "$answer" | grep -iq "^r" ;then

        echo "---------- Removing existing $MXE_BUILDROOT"
        chmod +w "$MXE_BUILDROOT/usr/readonly"
        chattr -i "$MXE_BUILDROOT/usr/readonly/.gitkeep"
        rm -rf "$MXE_BUILDROOT"

    elif echo "$answer" | grep -iq "^c" ;then

        echo "---------- Continue aborted previous installation in $MXE_BUILDROOT"
        CONTINUE_INSTALL=1

    else

        echo "---------- Aborting..."
        exit;

    fi

fi

if [[ $CONTINUE_INSTALL == 0 ]]; then

    #################################################################################################
    # Checkout latest Mxe from github

    git clone $MXE_GIT_URL $MXE_BUILDROOT

fi

#################################################################################################
# Mxe update

export PATH=$MXE_BUILDROOT/mxe/usr/bin:$MXE_BUILDROOT/mxe/usr/x86_64-w64-mingw32.shared/qt5/bin:$PATH
cd $MXE_BUILDROOT

echo -e "\n"
echo "---------- Updating Mxe"
git pull

#################################################################################################
# Dependencies build and installation

echo -e "\n"
echo "---------- Building digiKam dependencies with Mxe"

make MXE_TARGETS=$MXE_BUILD_TARGETS $MXE_PACKAGES

echo -e "\n"

#################################################################################################

export PATH=$ORIG_PATH

TerminateScript

exit 0
