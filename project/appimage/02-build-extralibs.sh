#!/bin/bash

# Script to build extra libraries using CentOs 6.
# This script must be run as sudo
#
# Copyright (c) 2015-2016, Gilles Caulier, <caulier dot gilles at gmail dot com>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.
#

# Halt on errors
set -e

#################################################################################################
# Manage script traces to log file

mkdir -p ./logs
exec > >(tee ./logs/build-extralibs.full.log) 2>&1

#################################################################################################

echo "02-build-extralibs.sh : build extra libraries under CentoOS 6."
echo "--------------------------------------------------------------"

#################################################################################################
# Pre-processing checks

. ./config.sh
. ./common.sh
StartScript
ChecksCPUCores
CentOS6Adjustments
. /opt/rh/devtoolset-4/enable

#################################################################################################

ORIG_WD="`pwd`"

# Make sure we build from the /, parts of this script depends on that. We also need to run as root...
cd  /

# start building the deps
cd /b

rm -rf /b/* || true

cmake3 $ORIG_WD/3rdparty \
       -DCMAKE_INSTALL_PREFIX:PATH=/usr \
       -DINSTALL_ROOT=/usr \
       -DEXTERNALS_DOWNLOAD_DIR=/d

# NOTE: The order to compile each component here is very important.

# extralibs and Qt5 dependencies
cmake3 --build . --config RelWithDebInfo --target ext_exiv2               -- -j$CPU_CORES
cmake3 --build . --config RelWithDebInfo --target ext_lcms2               -- -j$CPU_CORES
cmake3 --build . --config RelWithDebInfo --target ext_boost               -- -j$CPU_CORES
cmake3 --build . --config RelWithDebInfo --target ext_eigen3              -- -j$CPU_CORES
cmake3 --build . --config RelWithDebInfo --target ext_opencv              -- -j$CPU_CORES
cmake3 --build . --config RelWithDebInfo --target ext_lensfun             -- -j$CPU_CORES
cmake3 --build . --config RelWithDebInfo --target ext_qt                  -- -j$CPU_CORES
cmake3 --build . --config RelWithDebInfo --target ext_qtwebkit            -- -j$CPU_CORES

# core KF5 frameworks dependencies
cmake3 --build . --config RelWithDebInfo --target ext_extra_cmake_modules -- -j$CPU_CORES
cmake3 --build . --config RelWithDebInfo --target ext_kconfig             -- -j$CPU_CORES
cmake3 --build . --config RelWithDebInfo --target ext_breeze_icons        -- -j$CPU_CORES
cmake3 --build . --config RelWithDebInfo --target ext_solid               -- -j$CPU_CORES
cmake3 --build . --config RelWithDebInfo --target ext_kcoreaddons         -- -j$CPU_CORES
cmake3 --build . --config RelWithDebInfo --target ext_kwindowsystem       -- -j$CPU_CORES
cmake3 --build . --config RelWithDebInfo --target ext_solid               -- -j$CPU_CORES
cmake3 --build . --config RelWithDebInfo --target ext_threadweaver        -- -j$CPU_CORES
cmake3 --build . --config RelWithDebInfo --target ext_karchive            -- -j$CPU_CORES
cmake3 --build . --config RelWithDebInfo --target ext_kdbusaddons         -- -j$CPU_CORES
cmake3 --build . --config RelWithDebInfo --target ext_ki18n               -- -j$CPU_CORES
cmake3 --build . --config RelWithDebInfo --target ext_kcrash              -- -j$CPU_CORES
cmake3 --build . --config RelWithDebInfo --target ext_kcodecs             -- -j$CPU_CORES
cmake3 --build . --config RelWithDebInfo --target ext_kauth               -- -j$CPU_CORES
cmake3 --build . --config RelWithDebInfo --target ext_kguiaddons          -- -j$CPU_CORES
cmake3 --build . --config RelWithDebInfo --target ext_kwidgetsaddons      -- -j$CPU_CORES
cmake3 --build . --config RelWithDebInfo --target ext_kitemviews          -- -j$CPU_CORES
cmake3 --build . --config RelWithDebInfo --target ext_kcompletion         -- -j$CPU_CORES
cmake3 --build . --config RelWithDebInfo --target ext_kconfigwidgets      -- -j$CPU_CORES
cmake3 --build . --config RelWithDebInfo --target ext_kiconthemes         -- -j$CPU_CORES
cmake3 --build . --config RelWithDebInfo --target ext_kservice            -- -j$CPU_CORES
cmake3 --build . --config RelWithDebInfo --target ext_kglobalaccel        -- -j$CPU_CORES
cmake3 --build . --config RelWithDebInfo --target ext_kxmlgui             -- -j$CPU_CORES
cmake3 --build . --config RelWithDebInfo --target ext_kbookmarks          -- -j$CPU_CORES
cmake3 --build . --config RelWithDebInfo --target ext_kimageformats       -- -j$CPU_CORES

# Extra support for Kipi-plugins
cmake3 --build . --config RelWithDebInfo --target ext_kjobwidgets         -- -j$CPU_CORES
cmake3 --build . --config RelWithDebInfo --target ext_sonnet              -- -j$CPU_CORES
cmake3 --build . --config RelWithDebInfo --target ext_ktextwidgets        -- -j$CPU_CORES
cmake3 --build . --config RelWithDebInfo --target ext_kio                 -- -j$CPU_CORES
cmake3 --build . --config RelWithDebInfo --target ext_kwallet             -- -j$CPU_CORES
cmake3 --build . --config RelWithDebInfo --target ext_kparts              -- -j$CPU_CORES
cmake3 --build . --config RelWithDebInfo --target ext_kdewebkit           -- -j$CPU_CORES

# Linux Desktop support
cmake3 --build . --config RelWithDebInfo --target ext_knotifyconfig       -- -j$CPU_CORES
cmake3 --build . --config RelWithDebInfo --target ext_knotifications      -- -j$CPU_CORES

# Geolocation support
cmake3 --build . --config RelWithDebInfo --target ext_marble              -- -j$CPU_CORES

#################################################################################################

TerminateScript
