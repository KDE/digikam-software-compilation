# Script to build Qt for digiKam bundle.
#
# Copyright (c) 2015-2017, Gilles Caulier, <caulier dot gilles at gmail dot com>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.
#

SET(EXTPREFIX_qt "${EXTPREFIX}")

ExternalProject_Add(ext_qt
    DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}
    URL https://download.qt.io/official_releases/qt/5.7/5.7.1/single/qt-everywhere-opensource-src-5.7.1.tar.xz
    URL_MD5 7524ffba8411119d867f673155ec91bc    CONFIGURE_COMMAND <SOURCE_DIR>/configure
                  -prefix ${EXTPREFIX_qt}
                  -opensource
                  -confirm-license
                  -nomake examples
                  -sql-sqlite
                  -openssl
                  -optimized-qmake
                  -no-qml-debug
                  -no-mtdev
                  -no-journald
                  -no-syslog
                  -no-tslib
                  -no-directfb
                  -no-linuxfb
                  -no-libproxy
                  -no-pch
                  -no-compile-examples
                  -qt-zlib
                  -qt-pcre
                  -qt-harfbuzz
                  -qt-freetype
                  -qt-xcb
                  -qt-xkbcommon-x11
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
                  -skip qtvirtualkeyboard
                  -skip qtmultimedia
                  -skip qtlocation

    UPDATE_COMMAND ""
    BUILD_IN_SOURCE 1
    ALWAYS 0
)
