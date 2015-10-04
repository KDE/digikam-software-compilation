#! /bin/bash

# Script to build digiKam using MacPorts
# This script must be run as sudo
#
# Copyright (c) 2015, Gilles Caulier, <caulier dot gilles at gmail dot com>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.
#

#################################################################################################
# Manage script traces to log file

exec > >(tee build-digikam.full.log) 2>&1

#################################################################################################

echo "02-build-digikam.sh : build digiKam using MacPorts."
echo "---------------------------------------------------"

#################################################################################################
# Pre-processing checks

. ./configbundlepkg.sh
. ../common/common.sh
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
# Build OpenCV in temporary directory and installation

if [[ $ENABLE_OPENCV == 1 ]]; then

    if [ -d "$OC_BUILDTEMP" ] ; then
    echo "---------- Removing existing $OC_BUILDTEMP"
    rm -rf "$OC_BUILDTEMP"
    fi

    echo "---------- Creating $OC_BUILDTEMP"
    mkdir "$OC_BUILDTEMP"

    if [ $? -ne 0 ] ; then
        echo "---------- Cannot create $OC_BUILDTEMP directory."
        echo "---------- Aborting..."
        exit;
    fi

    cd "$OC_BUILDTEMP"
    echo -e "\n\n"

    echo "---------- Downloading OpenCV $OC_VERSION"

    curl -L -o "opencv-$OC_VERSION.zip" "$OC_URL/$OC_VERSION/opencv-$OC_VERSION.zip"

    unzip opencv-$OC_VERSION.zip
    cd opencv-$OC_VERSION

    echo -e "\n\n"

    echo "---------- Configuring OpenCV"

    cmake \
        -G "Unix Makefiles" \
        -DCMAKE_BUILD_TYPE=debugfull \
        -DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX} \
        -DCMAKE_OSX_ARCHITECTURES=x86_64 \
        -DCMAKE_CXX_FLAGS="${CMAKE_CXX_FLAGS} ${EXTRA_CXX_FLAGS}" \
        -DCMAKE_COLOR_MAKEFILE=ON \
        -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON \
        -DCMAKE_INSTALL_NAME_DIR=${INSTALL_PREFIX}/lib \
        -DCMAKE_SYSTEM_PREFIX_PATH="${INSTALL_PREFIX};/usr" \
        -DCMAKE_MODULE_PATH="${INSTALL_PREFIX}/share/cmake/modules" \
        -DBUILD_SHARED_LIBS=ON \
        -DBUILD_WITH_DEBUG_INFO=ON \
        -DBUILD_EXAMPLES=OFF \
        -DBUILD_TESTS=OFF \
        -DBUILD_DOCS=OFF \
        -DBUILD_PERF_TESTS=OFF \
        -DBUILD_NEW_PYTHON_SUPPORT=OFF \
        -DOPENCV_BUILD_3RDPARTY_LIBS=OFF \
        -DINSTALL_C_EXAMPLES=OFF \
        -DINSTALL_PYTHON_EXAMPLES=OFF \
        .

    echo -e "\n\n"

    echo "---------- Building OpenCV"
    make -j$CPU_CORES
    echo -e "\n\n"

    echo "---------- Installing OpenCV"
    echo -e "\n\n"
    make install && cd "$ORIG_WD" && rm -rf "$OC_BUILDTEMP"

fi

#################################################################################################
# Build Exiv2 in temporary directory and installation

if [[ $ENABLE_EXIV2 == 1 ]]; then

    if [ -d "$EX_BUILDTEMP" ] ; then
    echo "---------- Removing existing $EX_BUILDTEMP"
    rm -rf "$EX_BUILDTEMP"
    fi

    echo "---------- Creating $EX_BUILDTEMP"
    mkdir "$EX_BUILDTEMP"

    if [ $? -ne 0 ] ; then
        echo "---------- Cannot create $EX_BUILDTEMP directory."
        echo "---------- Aborting..."
        exit;
    fi

    cd "$EX_BUILDTEMP"
    echo -e "\n\n"

    echo "---------- Downloading Exiv2 $EX_VERSION"

    if [[ "$EX_VERSION" == "svn" ]] ; then
        svn checkout svn://dev.exiv2.org/svn/trunk exiv2-$EX_VERSION
        cd exiv2-$EX_VERSION
        make config
    else
        curl -L -o "exiv2-$EX_VERSION.tar.gz" "$EX_URL/exiv2-$EX_VERSION.tar.gz"
        tar zxvf exiv2-$EX_VERSION.tar.gz
        cd exiv2-$EX_VERSION
    fi

    echo -e "\n\n"

    echo "---------- Configuring Exiv2"

    cmake \
        -G "Unix Makefiles" \
        -DCMAKE_BUILD_TYPE=debugfull \
        -DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX} \
        -DCMAKE_OSX_ARCHITECTURES=x86_64 \
        -DCMAKE_CXX_FLAGS="${CMAKE_CXX_FLAGS} ${EXTRA_CXX_FLAGS}" \
        -DCMAKE_COLOR_MAKEFILE=ON \
        -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON \
        -DCMAKE_INSTALL_NAME_DIR=${INSTALL_PREFIX}/lib \
        -DCMAKE_SYSTEM_PREFIX_PATH="${INSTALL_PREFIX};/usr" \
        -DCMAKE_MODULE_PATH="${INSTALL_PREFIX}/share/cmake/modules" \
        -DEXIV2_ENABLE_SHARED=ON \
        -DEXIV2_ENABLE_XMP=ON \
        -DEXIV2_ENABLE_LIBXMP=ON \
        -DEXIV2_ENABLE_PNG=ON \
        -DEXIV2_ENABLE_NLS=ON \
        -DEXIV2_ENABLE_PRINTUCS2=ON \
        -DEXIV2_ENABLE_LENSDATA=ON \
        -DEXIV2_ENABLE_COMMERCIAL=OFF \
        -DEXIV2_ENABLE_BUILD_SAMPLES=OFF \
        -DEXIV2_ENABLE_BUILD_PO=ON \
        -DEXIV2_ENABLE_VIDEO=OFF \
        -DEXIV2_ENABLE_WEBREADY=OFF \
        -DEXIV2_ENABLE_CURL=OFF \
        -DEXIV2_ENABLE_SSH=OFF \
        .

    echo -e "\n\n"

    echo "---------- Building Exiv2"
    make -j$CPU_CORES
    echo -e "\n\n"

    echo "---------- Installing Exiv2"
    echo -e "\n\n"
    make install && cd "$ORIG_WD" && rm -rf "$EX_BUILDTEMP"

fi

#################################################################################################
# Build Lensfun in temporary directory and installation

if [[ $ENABLE_LENSFUN == 1 ]]; then

    if [ -d "$LF_BUILDTEMP" ] ; then
    echo "---------- Removing existing $LF_BUILDTEMP"
    rm -rf "$LF_BUILDTEMP"
    fi

    echo "---------- Creating $LF_BUILDTEMP"
    mkdir "$LF_BUILDTEMP"

    if [ $? -ne 0 ] ; then
        echo "---------- Cannot create $LF_BUILDTEMP directory."
        echo "---------- Aborting..."
        exit;
    fi

    cd "$LF_BUILDTEMP"
    echo -e "\n\n"

    echo "---------- Downloading Lensfun $LF_VERSION"

    curl -L -o "lensfun-$LF_VERSION.tar.gz" "$LF_URL/$LF_VERSION/lensfun-$LF_VERSION.tar.gz"

    tar zxvf lensfun-$LF_VERSION.tar.gz

    cd lensfun-$LF_VERSION
    # Fix linking with Glib2. cmake find script is buggous. We will pass Glib2 config at configuration time as well.
    touch -f ./build/CMakeModules/FindGLIB2.cmake
    echo -e "\n\n"

    echo "---------- Configuring Lensfun"

    cmake \
        -G "Unix Makefiles" \
        -DCMAKE_BUILD_TYPE=DEBUG \
        -DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX} \
        -DCMAKE_COLOR_MAKEFILE=ON \
        -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON \
        -DCMAKE_INSTALL_NAME_DIR=${INSTALL_PREFIX}/lib \
        -DCMAKE_SYSTEM_PREFIX_PATH="${INSTALL_PREFIX};/usr" \
        -DCMAKE_MODULE_PATH="${INSTALL_PREFIX}/share/cmake/modules" \
        -DCMAKE_OSX_ARCHITECTURES=x86_64 \
        -DCMAKE_CXX_FLAGS="${CMAKE_CXX_FLAGS} ${EXTRA_CXX_FLAGS}" \
        -DLENSFUN_INSTALL_PREFIX=${INSTALL_PREFIX} \
        -DBUILD_TESTS=OFF \
        -DBUILD_LENSTOOL=OFF \
        -DBUILD_DOC=OFF \
        -DINSTALL_HELPER_SCRIPTS=OFF \
        -DGLIB2_INCLUDE_DIR=${INSTALL_PREFIX}/include/glib-2.0/ \
        -DGLIB2_LIBRARIES=${INSTALL_PREFIX}/lib/libglib-2.0.dylib \
        .

    echo -e "\n\n"

    echo "---------- Building Lensfun"
    make -j$CPU_CORES
    echo -e "\n\n"

    echo "---------- Installing Lensfun"
    echo -e "\n\n"
    make install/fast && cd "$ORIG_WD" && rm -rf "$LF_BUILDTEMP"

fi

#################################################################################################
# Build Libraw in temporary directory and installation

if [[ $ENABLE_LIBRAW == 1 ]]; then

    if [ -d "$LR_BUILDTEMP" ] ; then
    echo "---------- Removing existing $LR_BUILDTEMP"
    rm -rf "$LR_BUILDTEMP"
    fi

    echo "---------- Creating $LR_BUILDTEMP"
    mkdir "$LR_BUILDTEMP"

    if [ $? -ne 0 ] ; then
        echo "---------- Cannot create $LR_BUILDTEMP directory."
        echo "---------- Aborting..."
        exit;
    fi

    cd "$LR_BUILDTEMP"
    echo -e "\n\n"

    echo "---------- Downloading Libraw $LR_VERSION"

    curl -L -o "LibRaw-$LR_VERSION.tar.gz" "$LR_URL/LibRaw-$LR_VERSION.tar.gz"
    curl -L -o "LibRaw-demosaic-pack-GPL2-$LR_VERSION.tar.gz" "$LR_URL/LibRaw-demosaic-pack-GPL2-$LR_VERSION.tar.gz"
    curl -L -o "LibRaw-demosaic-pack-GPL3-$LR_VERSION.tar.gz" "$LR_URL/LibRaw-demosaic-pack-GPL3-$LR_VERSION.tar.gz"

    tar zxvf LibRaw-$LR_VERSION.tar.gz
    tar zxvf LibRaw-demosaic-pack-GPL2-$LR_VERSION.tar.gz
    tar zxvf LibRaw-demosaic-pack-GPL3-$LR_VERSION.tar.gz

    cd LibRaw-$LR_VERSION
    echo -e "\n\n"

    echo "---------- Configuring LibRaw"

    ./configure \
        --prefix=$INSTALL_PREFIX \
        --enable-openmp \
        --enable-lcms \
        --disable-examples \
        --enable-demosaic-pack-gpl2 \
        --enable-demosaic-pack-gpl3

    echo -e "\n\n"

    echo "---------- Building LibRaw"
    make -j$CPU_CORES
    echo -e "\n\n"

    echo "---------- Installing LibRaw"
    echo -e "\n\n"
    make install && cd "$ORIG_WD" && rm -rf "$LR_BUILDTEMP"

fi

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
        -DCMAKE_BUILD_TYPE=debugfull \
        -DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX} \
        -DCMAKE_OSX_ARCHITECTURES=x86_64 \
        -DCMAKE_CXX_FLAGS="${CMAKE_CXX_FLAGS} ${EXTRA_CXX_FLAGS}" \
        -DCMAKE_COLOR_MAKEFILE=ON \
        -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON \
        -DCMAKE_INSTALL_NAME_DIR=${INSTALL_PREFIX}/lib \
        -DCMAKE_SYSTEM_PREFIX_PATH="${INSTALL_PREFIX};/usr" \
        -DCMAKE_MODULE_PATH="${INSTALL_PREFIX}/share/cmake/modules" \
        .

    echo -e "\n\n"

    echo "---------- Building Hugin"
    make -j$CPU_CORES
    echo -e "\n\n"

    echo "---------- Installing Hugin"
    echo -e "\n\n"
    make install && cd "$ORIG_WD" && rm -rf "$HU_BUILDTEMP"

fi

#################################################################################################
# Build digiKam in temporary directory and installation

if [ -d "$DK_BUILDTEMP" ] ; then
   echo "---------- Removing existing $DK_BUILDTEMP"
   rm -rf "$DK_BUILDTEMP"
fi

echo "---------- Creating $DK_BUILDTEMP"
mkdir "$DK_BUILDTEMP"

if [ $? -ne 0 ] ; then
    echo "---------- Cannot create $DK_BUILDTEMP directory."
    echo "---------- Aborting..."
    exit;
fi

cd "$DK_BUILDTEMP"
echo -e "\n\n"

echo "---------- Downloading digiKam $DK_VERSION"

if [[ "$DK_VERSION" == "git" ]] ; then
    git clone git@git.kde.org:digikam-software-compilation digikam-$DK_VERSION
    cd digikam-$DK_VERSION
    ./download-repos
else
    curl -L -o "digikam-$DK_VERSION.tar.bz2" "$DK_URL/digikam-$DK_VERSION.tar.bz2"
    tar jxvf digikam-$DK_VERSION.tar.bz2
    cd digikam-$DK_VERSION
fi

cp -f $ORIG_WD/../../../bootstrap.macports $DK_BUILDTEMP/digikam-$DK_VERSION
echo -e "\n\n"

echo "---------- Configure digiKam with CXX extra flags : $EXTRA_CXX_FLAGS"

./bootstrap.macports "$INSTALL_PREFIX" "debugfull" "x86_64" "$EXTRA_CXX_FLAGS"

echo -e "\n\n"

echo "---------- Building digiKam"
cd build
make -j$CPU_CORES
echo -e "\n\n"

echo "---------- Installing digiKam"
echo -e "\n\n"
make install/fast && cd "$ORIG_WD" && rm -rf "$DK_BUILDTEMP"

#################################################################################################

export PATH=$ORIG_PATH

TerminateScript
