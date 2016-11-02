# Script to build KF5 Framework for digiKam bundle.
#
# Copyright (c) 2015-2016, Gilles Caulier, <caulier dot gilles at gmail dot com>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.
#

set(EXTPREFIX_frameworks "${EXTPREFIX}")

set(KD_VERSION 5.27)

function(InstallKF5Component
         name
         version
         argoptions
         patch)

    # Extract MD5 sums of each KF5 components directly from server.
    execute_process(COMMAND
                    wget -q -O - -o /dev/null http://download.kde.org/stable/frameworks/${version}/${name}-${version}.0.tar.xz.mirrorlist
                    COMMAND
                    grep "MD5 Hash"
                    COMMAND
                    grep -o -P "(?<=<tt>).*(?=</tt>)"
                    OUTPUT_VARIABLE
                    md5sm
                    OUTPUT_STRIP_TRAILING_WHITESPACE
    )

    message(STATUS "--------------------------------")
    message(STATUS "KF5 component    : ${name}")
    message(STATUS "Component version: ${version}")
    message(STATUS "Component MD5    : ${md5sm}")
    message(STATUS "Configure options: ${argoptions}")
    message(STATUS "Patch to apply   : ${patch}")

    if(NOT "${patch}" STREQUAL "")
        set(patch "${PATCH_COMMAND};-p1;-i;${CMAKE_CURRENT_SOURCE_DIR}/../../patches/${patch}")
    endif()

    ExternalProject_Add(ext_${name}
                        DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}
                        URL http://download.kde.org/stable/frameworks/${version}/${name}-${version}.0.tar.xz
                        URL_MD5 ${md5sm}
                        INSTALL_DIR ${EXTPREFIX_frameworks}
                        CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${EXTPREFIX_frameworks}
                                   -DCMAKE_BUILD_TYPE=${GLOBAL_BUILD_TYPE}
                                   ${GLOBAL_PROFILE}
                                   -DCMAKE_SYSTEM_PREFIX_PATH=${EXTPREFIX}
                                   -DBUILD_TESTING=OFF
                                   "${argoptions}"
                                   -Wno-dev
                        PATCH_COMMAND ${patch}
                        UPDATE_COMMAND ""
                        ALWAYS 0
    )
endfunction()

InstallKF5Component(extra-cmake-modules ${KD_VERSION} ""                                               "")
InstallKF5Component(kconfig             ${KD_VERSION} ""                                               "")
InstallKF5Component(breeze-icons        ${KD_VERSION} ""                                               "")
InstallKF5Component(solid               ${KD_VERSION} ""                                               "")
InstallKF5Component(kcoreaddons         ${KD_VERSION} ""                                               "")
InstallKF5Component(threadweaver        ${KD_VERSION} ""                                               "")
InstallKF5Component(kwindowsystem       ${KD_VERSION} ""                                               "")
InstallKF5Component(karchive            ${KD_VERSION} ""                                               "")
InstallKF5Component(kdbusaddons         ${KD_VERSION} ""                                               "")
InstallKF5Component(ki18n               ${KD_VERSION} ""                                               "")
InstallKF5Component(kcrash              ${KD_VERSION} ""                                               "")
InstallKF5Component(kcodecs             ${KD_VERSION} ""                                               "")
InstallKF5Component(kauth               ${KD_VERSION} ""                                               "")
InstallKF5Component(kguiaddons          ${KD_VERSION} ""                                               "kguiaddons-helpurl.patch")
InstallKF5Component(kwidgetsaddons      ${KD_VERSION} ""                                               "")
InstallKF5Component(kitemviews          ${KD_VERSION} ""                                               "")
InstallKF5Component(kcompletion         ${KD_VERSION} ""                                               "")
InstallKF5Component(kconfigwidgets      ${KD_VERSION} ""                                               "")
InstallKF5Component(kiconthemes         ${KD_VERSION} ""                                               "")
InstallKF5Component(kservice            ${KD_VERSION} ""                                               "")
InstallKF5Component(kglobalaccel        ${KD_VERSION} ""                                               "")
InstallKF5Component(kxmlgui             ${KD_VERSION} ""                                               "kxmlgui-drop-ktextwidgets.patch")
InstallKF5Component(kbookmarks          ${KD_VERSION} ""                                               "")
InstallKF5Component(kimageformats       ${KD_VERSION} ""                                               "")
InstallKF5Component(knotifyconfig       ${KD_VERSION} ""                                               "")
InstallKF5Component(knotifications      ${KD_VERSION} ""                                               "knotifications-drop-phonon.patch")
InstallKF5Component(kjobwidgets         ${KD_VERSION} ""                                               "")
InstallKF5Component(sonnet              ${KD_VERSION} ""                                               "")
InstallKF5Component(ktextwidgets        ${KD_VERSION} ""                                               "")
InstallKF5Component(kio                 ${KD_VERSION} ""                                               "kio-signals-names.patch")
InstallKF5Component(kinit               ${KD_VERSION} ""                                               "")
InstallKF5Component(kdewebkit           ${KD_VERSION} ""                                               "")
InstallKF5Component(kwallet             ${KD_VERSION} "-DBUILD_KWALLETD=OFF;-DBUILD_KWALLET_QUERY=OFF" "")
