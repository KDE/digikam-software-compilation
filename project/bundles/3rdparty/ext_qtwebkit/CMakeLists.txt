# Script to build QtWebkit for digiKam bundle.
#
# Copyright (c) 2015-2017, Gilles Caulier, <caulier dot gilles at gmail dot com>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.
#

SET(EXTPREFIX_qtwebkit "${EXTPREFIX}")

ExternalProject_Add(ext_qtwebkit
    DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}
    URL https://download.qt.io/community_releases/5.7/5.7.1/qtwebkit-opensource-src-5.7.1.tar.xz
    URL_MD5 4fa8f47383ce36d59dcc36d701ce93cd
    INSTALL_DIR ${EXTPREFIX_qtwebkit}

    CONFIGURE_COMMAND qmake PREFIX=${EXTPREFIX_qtwebkit}
    UPDATE_COMMAND ""
    BUILD_IN_SOURCE 1
    ALWAYS 0
)
