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
InstallKDEExtraLib "threadweaver"
InstallKDEExtraLib "karchive"
InstallKDEExtraLib "kdbusaddons"
InstallKDEExtraLib "ki18n"
InstallKDEExtraLib "kcrash"
InstallKDEExtraLib "kcodecs"
InstallKDEExtraLib "kauth"
InstallKDEExtraLib "kguiaddons"
InstallKDEExtraLib "kwidgetsaddons"
InstallKDEExtraLib "kitemviews"
InstallKDEExtraLib "kcompletion"
InstallKDEExtraLib "kconfigwidgets"
InstallKDEExtraLib "kiconthemes"
InstallKDEExtraLib "kservice"
InstallKDEExtraLib "kglobalaccel"
InstallKDEExtraLib "kxmlgui" "$ORIG_WD/kxmlgui-drop-ktextwidgets.patch"
InstallKDEExtraLib "kbookmarks"
InstallKDEExtraLib "kjobwidgets"
InstallKDEExtraLib "kio" "$ORIG_WD/kio-drop-ktextwidgets.patch"

#################################################################################################
# Build KF5 extra components

# Marble for geolocation tools.

InstallKDEExtraApp "marble" "" \
                   "-DWITH_DESIGNER_PLUGIN=OFF \
                   -DBUILD_MARBLE_TESTS=OFF \
                   -DBUILD_MARBLE_TOOLS=OFF \
                   -DBUILD_MARBLE_EXAMPLES=OFF \
                   -DBUILD_MARBLE_APPS=OFF \
                   -DBUILD_MARBLE_TESTS=OFF \
                   -DBUILD_WITH_DBUS=OFF \
                   -DBUILD_TESTING=OFF \
                   -DQTONLY=ON \
                   -Wno-dev"

#################################################################################################

export PATH=$ORIG_PATH

# Build PNG2Ico CLI tool used by ECM for host OS.

cd $ORIG_WD/png2ico

cmake . \
      -DCMAKE_BUILD_TYPE=debug \
      -DCMAKE_COLOR_MAKEFILE=ON

make -j$CPU_CORES

#################################################################################################

cd "$ORIG_WD"

TerminateScript
