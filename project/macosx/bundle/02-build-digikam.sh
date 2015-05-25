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

echo "02-build-digikam.sh : build digiKam using MacPorts."
echo "---------------------------------------------------"

# Pre-processing checks
. ../common/common.sh
CommonSetup
ChecksRunAsRoot
ChecksXCodeCLI

#################################################################################################"

# Pathes rules
ORIG_PATH="$PATH"

#################################################################################################"
# Macports update

export PATH=$INSTALL_PREFIX/bin:/$INSTALL_PREFIX/sbin:$ORIG_PATH

echo -e "\n"
echo "---------- Updating MacPorts"
port -v selfupdate
echo -e "\n"

#################################################################################################"
# digiKam build and installation

# Use custom digikam portfile if digikam-portfile/Portfile exists
#[[ -f digikam-portfile/Portfile ]] && echo "*** Replacing digikam portfile with digikam-portfile/Portfile" && cp digikam-portfile/Portfile "`port file digikam`"

port clean --all digikam
port uninstall digikam
port install digikam +docs+lcms2+translations${DEBUG_SYMBOLS}

#################################################################################################"

export PATH=$ORIG_PATH
