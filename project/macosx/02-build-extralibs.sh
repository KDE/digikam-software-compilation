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

. ./config.sh
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

#################################################################################################
# Build KF5 frameworks in a temporary directory and installation
# See KF5DEPENDENCIES details about the big puzzle

InstallKDEExtraLib "extra-cmake-modules" ""                                                 "-DBUILD_TESTING=OFF -Wno-dev"
InstallKDEExtraLib "kconfig"             ""                                                 "-DBUILD_TESTING=OFF -Wno-dev"
InstallKDEExtraLib "breeze-icons"        ""                                                 "-DBUILD_TESTING=OFF -Wno-dev"
InstallKDEExtraLib "kcoreaddons"         ""                                                 "-DBUILD_TESTING=OFF -Wno-dev"
InstallKDEExtraLib "kwindowsystem"       ""                                                 "-DBUILD_TESTING=OFF -Wno-dev"
InstallKDEExtraLib "solid"               ""                                                 "-DBUILD_TESTING=OFF -Wno-dev"
InstallKDEExtraLib "threadweaver"        ""                                                 "-DBUILD_TESTING=OFF -Wno-dev"
InstallKDEExtraLib "karchive"            ""                                                 "-DBUILD_TESTING=OFF -Wno-dev"
InstallKDEExtraLib "kdbusaddons"         ""                                                 "-DBUILD_TESTING=OFF -Wno-dev"
InstallKDEExtraLib "ki18n"               ""                                                 "-DBUILD_TESTING=OFF -Wno-dev"
InstallKDEExtraLib "kcrash"              ""                                                 "-DBUILD_TESTING=OFF -Wno-dev"
InstallKDEExtraLib "kcodecs"             ""                                                 "-DBUILD_TESTING=OFF -Wno-dev"
InstallKDEExtraLib "kauth"               ""                                                 "-DBUILD_TESTING=OFF -Wno-dev"
InstallKDEExtraLib "kguiaddons"          ""                                                 "-DBUILD_TESTING=OFF -Wno-dev"
InstallKDEExtraLib "kwidgetsaddons"      ""                                                 "-DBUILD_TESTING=OFF -Wno-dev"
InstallKDEExtraLib "kitemviews"          ""                                                 "-DBUILD_TESTING=OFF -Wno-dev"
InstallKDEExtraLib "kcompletion"         ""                                                 "-DBUILD_TESTING=OFF -Wno-dev"
InstallKDEExtraLib "kconfigwidgets"      ""                                                 "-DBUILD_TESTING=OFF -Wno-dev"
InstallKDEExtraLib "kiconthemes"         ""                                                 "-DBUILD_TESTING=OFF -Wno-dev"
InstallKDEExtraLib "kservice"            ""                                                 "-DBUILD_TESTING=OFF -Wno-dev"
InstallKDEExtraLib "kglobalaccel"        ""                                                 "-DBUILD_TESTING=OFF -Wno-dev"
InstallKDEExtraLib "kxmlgui"             "$ORIG_WD/patches/kxmlgui-drop-ktextwidgets.patch" "-DBUILD_TESTING=OFF -Wno-dev"
InstallKDEExtraLib "kbookmarks"          ""                                                 "-DBUILD_TESTING=OFF -Wno-dev"
InstallKDEExtraLib "kjobwidgets"         ""                                                 "-DBUILD_TESTING=OFF -Wno-dev"
InstallKDEExtraLib "kio"                 "$ORIG_WD/patches/kio-drop-ktextwidgets.patch"     "-DBUILD_TESTING=OFF -Wno-dev"

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
mv $INSTALL_PREFIX/Marble.app/Contents/MacOS/lib/libastro*  $INSTALL_PREFIX/lib
mv $INSTALL_PREFIX/Marble.app/Contents/MacOS/lib/libmarble* $INSTALL_PREFIX/lib

# KCalCore for Calendar tool.
# Disabled currently due to dependencies to KDE4LibsSupport
#InstallKDEExtraApp "kcalcore"

#################################################################################################

export PATH=$ORIG_PATH

TerminateScript
