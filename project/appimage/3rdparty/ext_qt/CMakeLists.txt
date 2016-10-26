# Script to build Qt for digiKam bundle.
#
# Copyright (c) 2015-2016, Gilles Caulier, <caulier dot gilles at gmail dot com>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.
#

SET(EXTPREFIX_qt "${EXTPREFIX}")

    ExternalProject_Add(
        ext_qt
        DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}
        URL https://download.qt.io/official_releases/qt/5.7/5.7.0/single/qt-everywhere-opensource-src-5.7.0.tar.xz
        URL_MD5 63ec6b584757eef8cd713e4958297251
        INSTALL_DIR ${EXTPREFIX_qt}
        CONFIGURE_COMMAND <SOURCE_DIR>/configure
                      -prefix ${EXTPREFIX_qt}
                      -opensource
                      -confirm-license
                      -nomake examples
                      -sql-sqlite
                      -openssl
                      -no-qml-debug
                      -no-mtdev
                      -no-journald
                      -no-syslog
                      -no-nis
                      -no-cups
                      -no-tslib
                      -no-directfb
                      -no-linuxfb
                      -no-libproxy
                      -no-pch
                      -qt-zlib
                      -qt-pcre
                      -qt-libpng
                      -qt-libjpeg
                      -qt-harfbuzz
                      -qt-freetype
                      -qt-xcb
                      -qt-xkbcommon-x11
                      -optimized-qmake
                      -skip qt3d
                      -skip qtactiveqt
                      -skip qtcanvas3d
                      -skip qtconnectivity
                      -skip qtgraphicaleffects
                      -skip qtwayland
                      -skip qtwebchannel
                      -skip qtwebengine
                      -skip qtwebsockets
                      -skip qtandroidextras
                      -skip qtserialport
                      -skip qtgamepad
                      -skip qtmultimedia

        BUILD_COMMAND make
        INSTALL_COMMAND make install
        UPDATE_COMMAND ""
        BUILD_IN_SOURCE 1
        ALWAYS 0
    )


    ExternalProject_Add(
        ext_qt56
        DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}
        URL https://download.qt.io/official_releases/qt/5.6/5.6.2/single/qt-everywhere-opensource-src-5.6.2.tar.xz
        URL_MD5 5175fba2f221fd4c91e94771a57a5557
        INSTALL_DIR ${EXTPREFIX_qt}
        CONFIGURE_COMMAND <SOURCE_DIR>/configure
                      -prefix ${EXTPREFIX_qt}
                      -opensource
                      -confirm-license
                      -nomake examples
                      -sql-sqlite
                      -openssl
                      -no-qml-debug
                      -no-mtdev
                      -no-journald
                      -no-syslog
                      -no-cups
                      -no-tslib
                      -no-directfb
                      -no-linuxfb
                      -no-libproxy
                      -no-pch
                      -qt-zlib
                      -qt-pcre
                      -qt-libpng
                      -qt-libjpeg
                      -qt-harfbuzz
                      -qt-freetype
                      -qt-xcb
                      -qt-xkbcommon-x11
                      -optimized-qmake
                      -skip qt3d
                      -skip qtactiveqt
                      -skip qtcanvas3d
                      -skip qtconnectivity
                      -skip qtgraphicaleffects
                      -skip qtwayland
                      -skip qtwebchannel
                      -skip qtwebengine
                      -skip qtwebsockets
                      -skip qtandroidextras
                      -skip qtserialport
                      -skip qtmultimedia

        BUILD_COMMAND make
        INSTALL_COMMAND make install
        UPDATE_COMMAND ""
        BUILD_IN_SOURCE 1
        ALWAYS 0
    )
