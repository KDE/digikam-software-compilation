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
         md5sm
         argoptions
         patch)

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

InstallKF5Component(extra-cmake-modules ${KD_VERSION} "e8803aa94fe6f8c34cb3bd2d5a17756a" ""                                               "")
InstallKF5Component(kconfig             ${KD_VERSION} "e1a633ed10804ad00d53978bcfd906e7" ""                                               "")
InstallKF5Component(breeze-icons        ${KD_VERSION} "930313ace6621069059ebee94aa6b619" ""                                               "")
InstallKF5Component(solid               ${KD_VERSION} "9988adc243d0b4150aafb60120450749" ""                                               "")
InstallKF5Component(kcoreaddons         ${KD_VERSION} "3dc2ded3c06cbf5d0dcf41a96e9a03bb" ""                                               "")
InstallKF5Component(threadweaver        ${KD_VERSION} "d024d1973c6fa1ca2c636e4dc96570c4" ""                                               "")
InstallKF5Component(kwindowsystem       ${KD_VERSION} "91c9c0158573c6b42436b727a4596657" ""                                               "")
InstallKF5Component(karchive            ${KD_VERSION} "979133136e319640d2ff7caf4823185d" ""                                               "")
InstallKF5Component(kdbusaddons         ${KD_VERSION} "120036aa8aab440006d82198123e1bb6" ""                                               "")
InstallKF5Component(ki18n               ${KD_VERSION} "9b8848b193da6d8920d7853430408c0b" ""                                               "")
InstallKF5Component(kcrash              ${KD_VERSION} "e061460f6ffae7c3b1eee220d59e1dd4" ""                                               "")
InstallKF5Component(kcodecs             ${KD_VERSION} "85d8be54f0c19125c201b8fcb6a51169" ""                                               "")
InstallKF5Component(kauth               ${KD_VERSION} "345e44221759e83774dd10cfd64d3314" ""                                               "")
InstallKF5Component(kguiaddons          ${KD_VERSION} "f996e8d1abb275f10c1ebce6b13cbdc2" ""                                               "")
InstallKF5Component(kwidgetsaddons      ${KD_VERSION} "e3a44bed1791f6e0b5ac0b085b8af14b" ""                                               "")
InstallKF5Component(kitemviews          ${KD_VERSION} "1429c6dc5bdf7266b046ce8125801233" ""                                               "")
InstallKF5Component(kcompletion         ${KD_VERSION} "e4062d29440bf1d7bde8246a1c1e4365" ""                                               "")
InstallKF5Component(kconfigwidgets      ${KD_VERSION} "2584c4380f904b914801c3d0597fe3fc" ""                                               "")
InstallKF5Component(kiconthemes         ${KD_VERSION} "5d456438646adba8fb8e84bb5b5cc9ab" ""                                               "")
InstallKF5Component(kservice            ${KD_VERSION} "0b19bdee1e062b1f0ea267ba82e1132f" ""                                               "")
InstallKF5Component(kglobalaccel        ${KD_VERSION} "43773ce1c8a7411d0c5cd195c386a0a3" ""                                               "")
InstallKF5Component(kxmlgui             ${KD_VERSION} "2a409e1d18c37a8376c9a2f7aa1e3ed0" ""                                               "kxmlgui-drop-ktextwidgets.patch")
InstallKF5Component(kbookmarks          ${KD_VERSION} "7425331df90a2a4b4d4ef9b56d0e655c" ""                                               "")
InstallKF5Component(kimageformats       ${KD_VERSION} "5247b64759d284e1d89d84c954219f0c" ""                                               "")
InstallKF5Component(knotifyconfig       ${KD_VERSION} "c9eee11a2c0c78abfb5985f9875a33d2" ""                                               "")
InstallKF5Component(knotifications      ${KD_VERSION} "61fdefe03ef8dfcee7cffc27c84c4691" ""                                               "knotifications-drop-phonon.patch")
InstallKF5Component(kjobwidgets         ${KD_VERSION} "4fd4ab8f572b7418efb38ec6153f1217" ""                                               "")
InstallKF5Component(sonnet              ${KD_VERSION} "45bd0c4fe7f903980617bc818ee543e7" ""                                               "")
InstallKF5Component(ktextwidgets        ${KD_VERSION} "c32881a059bd4af1874262f682b0a2e5" ""                                               "")
InstallKF5Component(kio                 ${KD_VERSION} "b46b822a74a038531155a4189c12afae" ""                                               "")
InstallKF5Component(kwallet             ${KD_VERSION} "012d0e05887ede47f221d08474213dd8" "-DBUILD_KWALLETD=OFF;-DBUILD_KWALLET_QUERY=OFF" "")
