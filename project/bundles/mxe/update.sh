#!/bin/bash

# Script to update digiKam installer.
#
# Copyright (c) 2013-2017, Gilles Caulier, <caulier dot gilles at gmail dot com>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.
#

# halt on error
set -e

. ./config.sh
. ./common.sh
StartScript

echo "++++++++++++++++   Build 32 bits Installer   ++++++++++++++++++++++++++++++++++"
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

sed -e "s/MXE_ARCHBITS=64/MXE_ARCHBITS=32/g" ./config.sh > ./tmp.sh ; mv -f ./tmp.sh ./config.sh

./03-build-digikam.sh
./04-build-installer.sh

echo "++++++++++++++++   Build 64 bits Installer   ++++++++++++++++++++++++++++++++++"
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

sed -e "s/MXE_ARCHBITS=32/MXE_ARCHBITS=64/g" ./config.sh > ./tmp.sh ; mv -f ./tmp.sh ./config.sh

./03-build-digikam.sh
./04-build-installer.sh

echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

TerminateScript
