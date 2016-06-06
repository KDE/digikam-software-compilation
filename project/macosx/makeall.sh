#!/bin/bash

# Script to run all Macports based sub-scripts to build OSX installer.
# Possible option : "-f" to force operations without to ask confirmation to user.
#
# Copyright (c) 2013-2016, Gilles Caulier, <caulier dot gilles at gmail dot com>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.
#

#################################################################################################
# Pre-processing checks

. ./config.sh
. ./common.sh
StartScript
ChecksRunAsRoot
ChecksXCodeCLI
ChecksCPUCores

# halt on error
set -e

INSTALL_PREFIX=~/tmp
echo "This script will build from scratch the digiKam installer for OSX using Macports."
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

if [ -d "$INSTALL_PREFIX" ] ; then

    if [ "$1" != "-z" ] ; then

        read -p "A previous Macports build already exist and it will be removed. Do you want to continue ? [(c)ontinue/(s)top] " answer

        if echo "$answer" | grep -iq "^s" ; then

            echo "---------- Aborting..."
            exit;

        fi

    fi

    echo "---------- Removing existing Macports build"
    rm -fr $INSTALL_PREFIX

fi

./01-build-macports.sh
./02-build-extralibs.sh
./03-build-digikam.sh
./04-build-installer.sh

echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

TerminateScript
