# Script to build kcalcore for digiKam bundle.
#
# Copyright (c) 2015-2018, Gilles Caulier, <caulier dot gilles at gmail dot com>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.
#

set(EXTPREFIX_kcalcore "${EXTPREFIX}" )

set(KA_VERSION 17.12.0)

if(MINGW)
    ExternalProject_Add(
        ext_kcalcore
        DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}
        URL http://download.kde.org/stable/applications/${KA_VERSION}/src/kcalcore-${KA_VERSION}.tar.xz
        URL_MD5 c9df2814c18e4bd10a008b238c630c58
        INSTALL_DIR ${EXTPREFIX_kcalcore}
        PATCH_COMMAND ${PATCH_COMMAND} -p1 -i ${CMAKE_CURRENT_SOURCE_DIR}/kcalcore-ecm.patch

        CONFIGURE_COMMAND cp ${CMAKE_CURRENT_SOURCE_DIR}/../../../../bootstrap.mxe <SOURCE_DIR>/. &&
                          <SOURCE_DIR>/bootstrap.mxe ${MXE_BUILDROOT} RelWithDebInfo -DBUILD_TESTING=OFF

        BUILD_COMMAND cd <SOURCE_DIR>/build && $(MAKE)

        INSTALL_COMMAND cd <SOURCE_DIR>/build && make install/fast

        BUILD_IN_SOURCE 1

        UPDATE_COMMAND ""
        ALWAYS 0
    )
elseif(APPLE)
    ExternalProject_Add(
        ext_kcalcore
        DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}
        URL http://download.kde.org/stable/applications/${KA_VERSION}/src/kcalcore-${KA_VERSION}.tar.xz
        URL_MD5 c9df2814c18e4bd10a008b238c630c58
        INSTALL_DIR ${EXTPREFIX_kcalcore}
        PATCH_COMMAND ${PATCH_COMMAND} -p1 -i ${CMAKE_CURRENT_SOURCE_DIR}/kcalcore-ecm.patch

        CONFIGURE_COMMAND cp ${CMAKE_CURRENT_SOURCE_DIR}/../../../../bootstrap.macports <SOURCE_DIR>/. &&
                          <SOURCE_DIR>/bootstrap.macports ${EXTPREFIX_opencv} RelWithDebInfo x86_64 "${BASH_OPTIONS}"

        BUILD_COMMAND cd <SOURCE_DIR>/build && $(MAKE)

        INSTALL_COMMAND cd <SOURCE_DIR>/build && make install/fast

        BUILD_IN_SOURCE 1

        UPDATE_COMMAND ""
        ALWAYS 0
    )
else() # Linux
    ExternalProject_Add(
        ext_kcalcore
        DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}
        URL http://download.kde.org/stable/applications/${KA_VERSION}/src/kcalcore-${KA_VERSION}.tar.xz
        URL_MD5 c9df2814c18e4bd10a008b238c630c58
        INSTALL_DIR ${EXTPREFIX_kcalcore}
        PATCH_COMMAND ${PATCH_COMMAND} -p1 -i ${CMAKE_CURRENT_SOURCE_DIR}/kcalcore-ecm.patch

        CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${EXTPREFIX_kcalcore}
                   -DCMAKE_BUILD_TYPE=${GLOBAL_BUILD_TYPE}
                   ${GLOBAL_PROFILE}
                   -DCMAKE_SYSTEM_PREFIX_PATH=${EXTPREFIX}
                   -DBUILD_TESTING=OFF
                   -Wno-dev
        UPDATE_COMMAND ""
        ALWAYS 0
    )
endif()