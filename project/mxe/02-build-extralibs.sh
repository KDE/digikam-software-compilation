#! /bin/bash

# Script to build extra libraries using MEX env.
# This script must be run as sudo
#
# Copyright (c) 2015-2016, Gilles Caulier, <caulier dot gilles at gmail dot com>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.
#

#################################################################################################
# Manage script traces to log file

exec > >(tee build-extralibs.full.log) 2>&1

#################################################################################################

echo "02-build-extralibs.sh : build extra libraries using MEX."
echo "--------------------------------------------------------"

#################################################################################################
# Pre-processing checks

. ./configbundlemxe.sh
. ./common.sh
StartScript

#################################################################################################

# Pathes rules
ORIG_PATH="$PATH"
ORIG_WD="`pwd`"

export PATH=$MXE_BUILDROOT/usr/bin:$MXE_INSTALL_PREFIX/qt5/bin:$PATH
cd $MXE_BUILDROOT

#################################################################################################
# Build KF5 frameworks in a temporary directory and installation
# See KF5DEPENDENCIES details about the big puzzle

InstallKDEExtraLib "extra-cmake-modules"
InstallKDEExtraLib "kconfig"
InstallKDEExtraLib "kcoreaddons"
InstallKDEExtraLib "kwindowsystem"
InstallKDEExtraLib "solid"
InstallKDEExtraLib "karchive"
InstallKDEExtraLib "kdbusaddons"
InstallKDEExtraLib "ki18n"
InstallKDEExtraLib "kcrash"
InstallKDEExtraLib "kdoctools"
InstallKDEExtraLib "kcodecs"
InstallKDEExtraLib "kauth"
InstallKDEExtraLib "kguiaddons"
InstallKDEExtraLib "kwidgetsaddons"
InstallKDEExtraLib "kitemviews"
InstallKDEExtraLib "kcompletion"
InstallKDEExtraLib "kconfigwidgets"
InstallKDEExtraLib "kiconthemes"
InstallKDEExtraLib "kservice"
InstallKDEExtraLib "sonnet"
InstallKDEExtraLib "ktextwidgets"
InstallKDEExtraLib "attica"
InstallKDEExtraLib "kglobalaccel"
InstallKDEExtraLib "kxmlgui"
InstallKDEExtraLib "kbookmarks"
InstallKDEExtraLib "kjobwidgets"
InstallKDEExtraLib "kio"

#################################################################################################

export PATH=$ORIG_PATH

TerminateScript
