# Script to build Lensfun for digiKam bundle.
#
# Copyright (c) 2015-2016, Gilles Caulier, <caulier dot gilles at gmail dot com>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.
#

SET(EXTPREFIX_lensfun "${EXTPREFIX}" )

if (MINGW)

    ExternalProject_Add(ext_lensfun

        DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}

        URL http://downloads.sourceforge.net/project/lensfun/0.3.2/lensfun-0.3.2.tar.gz
        URL_MD5 247e59a0812ec451f6cd0d20b3379cb5

        PATCH_COMMAND ${PATCH_COMMAND} -p1 -i ${CMAKE_CURRENT_SOURCE_DIR}/lensfun-regex-mxe.patch

        CONFIGURE_COMMAND cp ${CMAKE_CURRENT_SOURCE_DIR}/../../../../bootstrap.mxe <SOURCE_DIR>/. &&
                          <SOURCE_DIR>/bootstrap.mxe ${MXE_BUILDROOT} relwithdebinfo ${GLOBAL_PROFILE}

        BUILD_COMMAND cd <SOURCE_DIR>/build && make -j

        INSTALL_COMMAND cd <SOURCE_DIR>/build && make install/fast

        BUILD_IN_SOURCE 1

        UPDATE_COMMAND ""
        ALWAYS 0
    )

else()

    ExternalProject_Add(ext_lensfun

        DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}

        URL http://downloads.sourceforge.net/project/lensfun/0.3.2/lensfun-0.3.2.tar.gz
        URL_MD5 247e59a0812ec451f6cd0d20b3379cb5

        INSTALL_DIR ${EXTPREFIX_lensfun}

        CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${EXTPREFIX_lensfun}
                   -DCMAKE_BUILD_TYPE=${GLOBAL_BUILD_TYPE}
                   ${GLOBAL_PROFILE}

        UPDATE_COMMAND ""
        ALWAYS 0
    )

endif()
