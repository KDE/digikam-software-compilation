#! /bin/bash

# Script to give a console with port CLI tool branched to MAcports bundle repository
# This script must be run as sudo
#
# Copyright (c) 2015, Gilles Caulier, <caulier dot gilles at gmail dot com>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.
#

. ../common/common.sh
CommonSetup
ChecksRunAsRoot
ChecksXCodeCLI

export PATH=$INSTALL_PREFIX/bin:/$INSTALL_PREFIX/sbin:$ORIG_PATH

port

export PATH=$ORIG_PATH
