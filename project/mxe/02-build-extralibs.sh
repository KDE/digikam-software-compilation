#! /bin/bash

# Script to build extra libraries using MEX.
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

echo "02-build-extralibs.sh : build extra libraries using MEX."
echo "--------------------------------------------------------"

#################################################################################################
# Pre-processing checks

. ./configbundlemxe.sh
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
# Build Hugin in temporary directory and installation

if [[ $ENABLE_HUGIN == 1 ]]; then

    if [ -d "$HU_BUILDTEMP" ] ; then
    echo "---------- Removing existing $HU_BUILDTEMP"
    rm -rf "$HU_BUILDTEMP"
    fi

    echo "---------- Creating $HU_BUILDTEMP"
    mkdir "$HU_BUILDTEMP"

    if [ $? -ne 0 ] ; then
        echo "---------- Cannot create $HU_BUILDTEMP directory."
        echo "---------- Aborting..."
        exit;
    fi

    cd "$HU_BUILDTEMP"
    echo -e "\n\n"

    echo "---------- Downloading Hugin $HU_VERSION"

    curl -L -o "hugin-$HU_VERSION.tar.bz2" "$HU_URL/hugin-$HU_VERSION/hugin-$HU_VERSION.0.tar.bz2"

    tar jxvf hugin-$HU_VERSION.tar.bz2
    cd hugin-$HU_VERSION.0

    echo -e "\n\n"

    echo "---------- Configuring Hugin"

    cmake \
        -G "Unix Makefiles" \
        -DMXE_TOOLCHAIN=${MXE_TOOLCHAIN} \
        -DCMAKE_BUILD_TYPE=relwithdebinfo \
        -DCMAKE_COLOR_MAKEFILE=ON \
        -DCMAKE_INSTALL_PREFIX=${MXE_INSTALL_PREFIX} \
        -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON \
        -DCMAKE_TOOLCHAIN_FILE=${MXE_TOOLCHAIN} \
        -DCMAKE_FIND_PREFIX_PATH=${CMAKE_PREFIX_PATH} \
        -DCMAKE_SYSTEM_INCLUDE_PATH=${CMAKE_PREFIX_PATH}/include \
        -DCMAKE_INCLUDE_PATH=${CMAKE_PREFIX_PATH}/include \
        -DCMAKE_LIBRARY_PATH=${CMAKE_PREFIX_PATH}/lib \
        -DZLIB_ROOT=${CMAKE_PREFIX_PATH} \
        -DOpenCV_DIR=${MXE_INSTALL_PREFIX}/lib \
        .

    echo -e "\n\n"

    echo "---------- Building Hugin"
    make -j$CPU_CORES
    echo -e "\n\n"

    echo "---------- Installing Hugin"
    echo -e "\n\n"
    make install && cd "$ORIG_WD" && rm -rf "$HU_BUILDTEMP"

fi
exit

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
mv $MXE_INSTALL_PREFIX/libastro* $MXE_INSTALL_PREFIX/bin
mv $MXE_INSTALL_PREFIX/libmarble* $MXE_INSTALL_PREFIX/bin

# KCalCore for Calendar tool.
# Disabled currently due to dependencies to KDE4LibsSupport
#InstallKDEExtraApp "kcalcore"

#################################################################################################

export PATH=$ORIG_PATH

# Build PNG2Ico CLI tool used by ECM for host OS.

cd $ORIG_WD/png2ico

cmake . \
      -DCMAKE_BUILD_TYPE=debug \
      -DCMAKE_COLOR_MAKEFILE=ON \
      -Wno-dev

make -j$CPU_CORES

#################################################################################################

cd "$ORIG_WD"

TerminateScript
