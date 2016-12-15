# Script to build QtAV for digiKam bundle.
#
# Copyright (c) 2015-2017, Gilles Caulier, <caulier dot gilles at gmail dot com>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.
#

set(PREFIX_ext_qtav "${EXTPREFIX}")

if (${MXE_ARCHBITS} MATCHES "64")
    set(LIB_DIR "lib_win_x86_64")
else()
    set(LIB_DIR "lib_win_x86")
endif()

if(MINGW)

    ExternalProject_Add(ext_qtav

        DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}

        GIT_REPOSITORY https://github.com/wang-bin/QtAV.git
        GIT_TAG v1.11.0

        PATCH_COMMAND ${PATCH_COMMAND} -p1 -i ${CMAKE_CURRENT_SOURCE_DIR}/qtav-signals-slots.patch

        CONFIGURE_COMMAND rm -rfv ${MXE_INSTALL_PREFIX}/qt5/include/QtAV &&
                          rm -rfv ${MXE_INSTALL_PREFIX}/qt5/include/QtAVWidgets &&
                          rm -fv  ${MXE_INSTALL_PREFIX}/qt5/lib/libQtAV1.a &&
                          rm -fv  ${MXE_INSTALL_PREFIX}/qt5/lib/libQtAVWidgets1.a &&
                          rm -fv  ${MXE_INSTALL_PREFIX}/qt5/bin/QtAV1.dll &&
                          rm -fv  ${MXE_INSTALL_PREFIX}/qt5/bin/QtAVWidgets1.dll &&
                          ${MXE_INSTALL_PREFIX}/qt5/bin/qmake PREFIX=${PREFIX_ext_qtav} CONFIG+=no_examples

        BUILD_COMMAND make

        INSTALL_COMMAND cp -rfv <SOURCE_DIR>/src/QtAV ${MXE_INSTALL_PREFIX}/qt5/include/ &&
                        cp -rfv <SOURCE_DIR>/widgets/QtAVWidgets ${MXE_INSTALL_PREFIX}/qt5/include/ &&
                        cp -fv  <SOURCE_DIR>/${LIB_DIR}/libQtAV1.a ${MXE_INSTALL_PREFIX}/qt5/lib/ &&
                        cp -fv  <SOURCE_DIR>/${LIB_DIR}/libQtAVWidgets1.a ${MXE_INSTALL_PREFIX}/qt5/lib/ &&
                        cp -fv  <SOURCE_DIR>/${LIB_DIR}/QtAV1.dll ${MXE_INSTALL_PREFIX}/qt5/bin/ &&
                        cp -fv  <SOURCE_DIR>/${LIB_DIR}/QtAVWidgets1.dll ${MXE_INSTALL_PREFIX}/qt5/bin/

        BUILD_IN_SOURCE 1

        UPDATE_COMMAND ""
        ALWAYS 0
    )

elseif(APPLE)

    ExternalProject_Add(ext_qtav

        DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}

        GIT_REPOSITORY https://github.com/wang-bin/QtAV.git
        GIT_TAG v1.11.0

        PATCH_COMMAND rm -rfv ${INSTALL_ROOT}/libexec/qt5/lib/QtAV.framework &&
                      rm -rfv ${INSTALL_ROOT}/libexec/qt5/lib/QtAVWidgets.framework &&
                      ${PATCH_COMMAND} -p1 -i ${CMAKE_CURRENT_SOURCE_DIR}/qtav-signals-slots.patch &&
                      ${PATCH_COMMAND} -p1 -i ${CMAKE_CURRENT_SOURCE_DIR}/qtav-rules-macos.patch

        CONFIGURE_COMMAND mkdir build && cd build && qmake ../QtAV.pro

        BUILD_COMMAND cd build && make

        INSTALL_COMMAND cp -rfv <SOURCE_DIR>/build/lib_osx_x86_64_llvm/QtAV.framework ${INSTALL_ROOT}/libexec/qt5/lib/ &&
                        cp -rfv <SOURCE_DIR>/build/lib_osx_x86_64_llvm/QtAVWidgets.framework ${INSTALL_ROOT}/libexec/qt5/lib/

        BUILD_IN_SOURCE 1

        UPDATE_COMMAND ""
        ALWAYS 0
    )

else() #Linux

    ExternalProject_Add(ext_qtav

        DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}

        GIT_REPOSITORY https://github.com/wang-bin/QtAV.git
        GIT_TAG v1.11.0

        PATCH_COMMAND ${PATCH_COMMAND} -p1 -i ${CMAKE_CURRENT_SOURCE_DIR}/qtav-signals-slots.patch

        CONFIGURE_COMMAND qmake PREFIX=${PREFIX_ext_qtav} CONFIG+=no_examples

        BUILD_COMMAND make

        INSTALL_COMMAND make install

        BUILD_IN_SOURCE 1

        UPDATE_COMMAND ""
        ALWAYS 0
    )

endif()
