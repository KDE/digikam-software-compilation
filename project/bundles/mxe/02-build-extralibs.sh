#! /bin/bash

# Script to build extra libraries using MEX.
#
# Copyright (c) 2015-2016, Gilles Caulier, <caulier dot gilles at gmail dot com>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.
#

# Halt on error
set -e

#################################################################################################
# Manage script traces to log file

mkdir -p ./logs
exec > >(tee ./logs/build-extralibs.full.log) 2>&1

#################################################################################################

echo "02-build-extralibs.sh : build extra libraries using MEX."
echo "--------------------------------------------------------"

#################################################################################################
# Pre-processing checks

. ./config.sh
. ./common.sh
StartScript
ChecksCPUCores

#################################################################################################

# Pathes rules
ORIG_PATH="$PATH"
ORIG_WD="`pwd`"

export PATH=$MXE_BUILDROOT/usr/bin:$MXE_INSTALL_PREFIX/qt5/bin:$PATH
cd $MXE_BUILDROOT

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
InstallKDEExtraLib "kimageformats"       ""                                                 "-DBUILD_TESTING=OFF -Wno-dev"

#################################################################################################
# Build KF5 extra components

# Marble for geolocation tools.

InstallKDEExtraApp "marble"              "$ORIG_WD/patches/marble-libs-install.patch"       "-DWITH_DESIGNER_PLUGIN=OFF \
                                                                                             -DBUILD_MARBLE_TESTS=OFF \
                                                                                             -DBUILD_MARBLE_TOOLS=OFF \
                                                                                             -DBUILD_MARBLE_EXAMPLES=OFF \
                                                                                             -DBUILD_MARBLE_APPS=OFF \
                                                                                             -DBUILD_WITH_DBUS=OFF \
                                                                                             -DBUILD_TESTING=OFF \
                                                                                             -DQTONLY=ON \
                                                                                             -Wno-dev"

# Marble install shared lib at wrong place.
mv $MXE_INSTALL_PREFIX/libastro* $MXE_INSTALL_PREFIX/bin
mv $MXE_INSTALL_PREFIX/libmarble* $MXE_INSTALL_PREFIX/bin

# KCalCore for Calendar tool.
# Disabled currently due to dependencies to KDE4LibsSupport
#InstallKDEExtraApp "kcalcore"

#################################################################################################

export PATH=$ORIG_PATH

# Build PNG2Ico CLI tool used by ECM for host OS.

cd $ORIG_WD/png2ico

rm -f CMakeCache.txt > /dev/null

cmake . \
      -DCMAKE_BUILD_TYPE=debug \
      -DCMAKE_COLOR_MAKEFILE=ON \
      -Wno-dev

make -j$CPU_CORES

#################################################################################################

cd "$ORIG_WD"

export PATH=$ORIG_PATH

TerminateScript
