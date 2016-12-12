# Script to build QtAV for digiKam bundle.
#
# Copyright (c) 2015-2017, Gilles Caulier, <caulier dot gilles at gmail dot com>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.
#

set(PREFIX_ext_qtav "${EXTPREFIX}")

if(MINGW)

    ExternalProject_Add(ext_qtav

        DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}

        GIT_REPOSITORY https://github.com/wang-bin/QtAV.git
        GIT_TAG v1.11.0

        CONFIGURE_COMMAND ${MXE_INSTALL_PREFIX}/qt5/bin/qmake DESTDIR=${PREFIX_ext_qtav} CONFIG+=no_examples

        BUILD_COMMAND make

        INSTALL_COMMAND cp -rf <SOURCE_DIR>/src/QtAV ${MXE_INSTALL_PREFIX}/qt5/include/ &&
                        cp -rf <SOURCE_DIR>/widgets/QtAVWidgets ${MXE_INSTALL_PREFIX}/qt5/include/ &&
                        cp -f  <SOURCE_DIR>/lib_win_x86/QtAV.prl ${MXE_INSTALL_PREFIX}/qt5/lib &&
                        cp -f  <SOURCE_DIR>/lib_win_x86/QtAVWidgets.prl ${MXE_INSTALL_PREFIX}/qt5/lib &&
                        cp -f  <SOURCE_DIR>/lib_win_x86/libQtAV1.a ${MXE_INSTALL_PREFIX}/qt5/lib/libQtAV.a &&
                        cp -f  <SOURCE_DIR>/lib_win_x86/libQtAVWidgets1.a ${MXE_INSTALL_PREFIX}/qt5/lib/libQtAVWidgets.a &&
                        cp -f  <SOURCE_DIR>/lib_win_x86/QtAV1.dll ${MXE_INSTALL_PREFIX}/qt5/bin/QtAV.dll &&
                        cp -f  <SOURCE_DIR>/lib_win_x86/QtAVWidgets1.dll ${MXE_INSTALL_PREFIX}/qt5/bin/QtAVWidgets.dll

        BUILD_IN_SOURCE 1

        UPDATE_COMMAND ""
        ALWAYS 0
    )

elseif(APPLE)

    ExternalProject_Add(ext_qtav

        DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}

        GIT_REPOSITORY https://github.com/wang-bin/QtAV.git
        GIT_TAG v1.11.0

        CONFIGURE_COMMAND qmake PREFIX=${PREFIX_ext_qtav}

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

        CONFIGURE_COMMAND qmake PREFIX=${PREFIX_ext_qtav}

        BUILD_COMMAND make

        INSTALL_COMMAND make install

        BUILD_IN_SOURCE 1

        UPDATE_COMMAND ""
        ALWAYS 0
    )

endif()
