# Script to build libksane for digiKam bundle.
#
# Copyright (c) 2015-2017, Gilles Caulier, <caulier dot gilles at gmail dot com>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.
#

set(EXTPREFIX_libksane "${EXTPREFIX}" )

set(KA_VERSION 16.08.2)

ExternalProject_Add(
    ext_libksane
    DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}
    URL http://download.kde.org/stable/applications/${KA_VERSION}/src/libksane-${KA_VERSION}.tar.xz
    URL_MD5 359f86cafe2b9780e17c6d6c78f983aa
    INSTALL_DIR ${EXTPREFIX_libksane}
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${EXTPREFIX_libksane}
               -DCMAKE_BUILD_TYPE=${GLOBAL_BUILD_TYPE}
               ${GLOBAL_PROFILE}
               -DCMAKE_SYSTEM_PREFIX_PATH=${EXTPREFIX}
               -DWITH_DESIGNER_PLUGIN=OFF
               -DBUILD_TESTING=OFF
               -Wno-dev
    UPDATE_COMMAND ""
    ALWAYS 0
)
