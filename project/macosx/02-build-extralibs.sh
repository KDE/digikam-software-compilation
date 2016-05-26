#! /bin/bash

# Script to build extra libraries using MacPorts env.
# This script must be run as sudo
#
# Copyright (c) 2015-2016, Gilles Caulier, <caulier dot gilles at gmail dot com>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.
#

#################################################################################################
# Manage script traces to log file

mkdir -p ./logs
exec > >(tee ./logs/build-extralibs.full.log) 2>&1

#################################################################################################

echo "02-build-extralibs.sh : build extra libraries using MacPorts."
echo "-------------------------------------------------------------"

#################################################################################################
# Pre-processing checks

. ./configbundlepkg.sh
. ./common.sh
StartScript
ChecksRunAsRoot
ChecksXCodeCLI
ChecksCPUCores
OsxCodeName

#################################################################################################

# Pathes rules
ORIG_PATH="$PATH"
ORIG_WD="`pwd`"

export PATH=$INSTALL_PREFIX/bin:/$INSTALL_PREFIX/sbin:$ORIG_PATH

if [[ $MAJOR_OSX_VERSION -lt 9 ]]; then
    EXTRA_CXX_FLAGS="-mmacosx-version-min=10.7 -stdlib=libc++"
else
    EXTRA_CXX_FLAGS=""
fi

#################################################################################################
# Build KF5 frameworks in a temporary directory and installation
# See KF5DEPENDENCIES details about the big puzzle

InstallKDEExtraLib "extra-cmake-modules"
InstallKDEExtraLib "kconfig"
InstallKDEExtraLib "breeze-icons"
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
InstallKDEExtraLib "kxmlgui" "$ORIG_WD/patches/kxmlgui-drop-ktextwidgets.patch"
InstallKDEExtraLib "kbookmarks"
InstallKDEExtraLib "kjobwidgets"
InstallKDEExtraLib "kio" "$ORIG_WD/patches/kio-drop-ktextwidgets.patch"

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

# Marble install shared lib at wrong place.
#mv $MXE_INSTALL_PREFIX/libastro* $MXE_INSTALL_PREFIX/bin
#mv $MXE_INSTALL_PREFIX/libmarble* $MXE_INSTALL_PREFIX/bin

# KCalCore for Calendar tool.
# Disabled currently due to dependencies to KDE4LibsSupport
#InstallKDEExtraApp "kcalcore"

#################################################################################################

export PATH=$ORIG_PATH

TerminateScript
