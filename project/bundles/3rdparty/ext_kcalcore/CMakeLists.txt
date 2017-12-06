# Script to build kcalcore for digiKam bundle.
#
# Copyright (c) 2015-2018, Gilles Caulier, <caulier dot gilles at gmail dot com>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.
#

set(EXTPREFIX_kcalcore "${EXTPREFIX}" )

set(KA_VERSION 17.08.1)

ExternalProject_Add(
    ext_kcalcore
    DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}
    URL http://download.kde.org/stable/applications/${KA_VERSION}/src/kcalcore-${KA_VERSION}.tar.xz
    URL_MD5 7262c40c5a8fa1e60cf871517ea47802
    INSTALL_DIR ${EXTPREFIX_kcalcore}
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${EXTPREFIX_kcalcore}
               -DCMAKE_BUILD_TYPE=${GLOBAL_BUILD_TYPE}
               ${GLOBAL_PROFILE}
               -DCMAKE_SYSTEM_PREFIX_PATH=${EXTPREFIX}
               -DBUILD_TESTING=OFF
               -Wno-dev
    UPDATE_COMMAND ""
    ALWAYS 0
)
