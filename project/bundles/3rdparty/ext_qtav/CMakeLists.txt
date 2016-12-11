# Script to build QtAV for digiKam bundle.
#
# Copyright (c) 2015-2017, Gilles Caulier, <caulier dot gilles at gmail dot com>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.
#

set(EXTPREFIX_qtav "${EXTPREFIX}")

if(MINGW)

    ExternalProject_Add(ext_qtav

        DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}

        GIT_REPOSITORY https://github.com/wang-bin/QtAV.git
        GIT_TAG v1.11.0

        CONFIGURE_COMMAND qmake

        BUILD_COMMAND make

        INSTALL_COMMAND make install

        BUILD_IN_SOURCE 1

        UPDATE_COMMAND ""
        ALWAYS 0
    )

elseif(APPLE)

    ExternalProject_Add(ext_qtav

        DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}

        GIT_REPOSITORY https://github.com/wang-bin/QtAV.git
        GIT_TAG v1.11.0

        CONFIGURE_COMMAND qmake

        BUILD_COMMAND make

        INSTALL_COMMAND make install

        BUILD_IN_SOURCE 1

        UPDATE_COMMAND ""
        ALWAYS 0
    )

else() #Linux

    ExternalProject_Add(ext_qtav

        DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}

        GIT_REPOSITORY https://github.com/wang-bin/QtAV.git
        GIT_TAG v1.11.0

        CONFIGURE_COMMAND qmake

        BUILD_COMMAND make

        INSTALL_COMMAND make install

        BUILD_IN_SOURCE 1

        UPDATE_COMMAND ""
        ALWAYS 0
    )

endif()
