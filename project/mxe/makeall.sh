#!/bin/sh

# Copyright (c) 2013-2016, Gilles Caulier, <caulier dot gilles at gmail dot com>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.

# halt on error
set -e

chmod +w "./build/usr/readonly"
chattr -i "./build/usr/readonly/.gitkeep"
rm -fr ./build

./01-build-mxe.sh
./02-build-extralibs.sh
./03-build-digikam.sh
./04-build-installer.sh
