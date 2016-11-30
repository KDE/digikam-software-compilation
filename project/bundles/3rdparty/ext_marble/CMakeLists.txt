# Script to build Marble for digiKam bundle.
#
# Copyright (c) 2015-2016, Gilles Caulier, <caulier dot gilles at gmail dot com>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.
#

set(EXTPREFIX_marble "${EXTPREFIX}" )

set(KA_VERSION 16.04.3)

if(APPLE)

    ExternalProject_Add(ext_marble
                        DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}
                        URL http://download.kde.org/stable/applications/${KA_VERSION}/src/marble-${KA_VERSION}.tar.xz
                        URL_MD5 e2e6315ba8277027f03ee2b5fe9c84a6

                        PATCH_COMMAND ${PATCH_COMMAND} -p1 -i ${CMAKE_CURRENT_SOURCE_DIR}/marble-libs-install-macports.patch &&
                                      cp ${CMAKE_CURRENT_SOURCE_DIR}/../../macports/fixbundledatapath.sh <SOURCE_DIR>/. &&
                                      <SOURCE_DIR>/fixbundledatapath.sh

                        CONFIGURE_COMMAND cp ${CMAKE_CURRENT_SOURCE_DIR}/../../../../bootstrap.macports <SOURCE_DIR>/. &&
                                          <SOURCE_DIR>/bootstrap.macports ${EXTPREFIX_marble} debug x86_64 "-DWITH_DESIGNER_PLUGIN=OFF -DBUILD_MARBLE_TESTS=OFF -DBUILD_MARBLE_TOOLS=OFF -DBUILD_MARBLE_EXAMPLES=OFF -DBUILD_MARBLE_APPS=OFF -DBUILD_WITH_DBUS=OFF -DQTONLY=ON -DBUILD_TESTING=OFF -Wno-dev"

                        BUILD_COMMAND cd <SOURCE_DIR>/build && make -j

                        INSTALL_COMMAND cd <SOURCE_DIR>/build && make install/fast

                        BUILD_IN_SOURCE 1

                        UPDATE_COMMAND ""
                        ALWAYS 0
        )

else() # Linux

    ExternalProject_Add(ext_marble
                        DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}
                        URL http://download.kde.org/stable/applications/${KA_VERSION}/src/marble-${KA_VERSION}.tar.xz
                        URL_MD5 e2e6315ba8277027f03ee2b5fe9c84a6

                        INSTALL_DIR ${EXTPREFIX_marble}
                        PATCH_COMMAND ${PATCH_COMMAND} -p1 -i ${CMAKE_CURRENT_SOURCE_DIR}/marble-libs-install-appimage.patch

                        CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${EXTPREFIX_marble}
                                   -DCMAKE_BUILD_TYPE=${GLOBAL_BUILD_TYPE}
                                   ${GLOBAL_PROFILE}
                                   -DCMAKE_SYSTEM_PREFIX_PATH=${EXTPREFIX_marble}
                                   -DWITH_DESIGNER_PLUGIN=OFF
                                   -DBUILD_MARBLE_TESTS=OFF
                                   -DBUILD_MARBLE_TOOLS=OFF
                                   -DBUILD_MARBLE_EXAMPLES=OFF
                                   -DBUILD_MARBLE_APPS=OFF
                                   -DBUILD_WITH_DBUS=OFF
                                   -DQTONLY=ON
                                   -DBUILD_TESTING=OFF
                                   -Wno-dev

                        UPDATE_COMMAND ""
                        ALWAYS 0
    )

endif()
