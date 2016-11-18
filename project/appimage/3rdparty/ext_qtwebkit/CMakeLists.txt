# Script to build QtWebkit for digiKam bundle.
#
# Copyright (c) 2015-2016, Gilles Caulier, <caulier dot gilles at gmail dot com>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.
#

SET(EXTPREFIX_qtwebkit "${EXTPREFIX}")

ExternalProject_Add(ext_qtwebkit
    DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}
    URL https://download.qt.io/community_releases/5.7/5.7.0/qtwebkit-opensource-src-5.7.0.tar.xz
    URL_MD5 9379b8829639645c184fa63532035098
    INSTALL_DIR ${EXTPREFIX_qtwebkit}

    CONFIGURE_COMMAND qmake PREFIX=${EXTPREFIX_qtwebkit}
    UPDATE_COMMAND ""
    BUILD_IN_SOURCE 1
    ALWAYS 0
)
