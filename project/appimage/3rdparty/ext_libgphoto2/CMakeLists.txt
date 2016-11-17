# Script to build libgphoto for digiKam bundle.
#
# Copyright (c) 2015-2016, Gilles Caulier, <caulier dot gilles at gmail dot com>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.
#

SET(EXTPREFIX_libgphoto2 "${EXTPREFIX}")

ExternalProject_Add(ext_libgphoto2
    DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}
    URL http://downloads.sourceforge.net/project/gphoto/libgphoto/2.5.10/libgphoto2-2.5.10.tar.bz2
    URL_MD5 f1e53e684a3ea51cc7958d7e4eee7f37

    PATCH_COMMAND ${PATCH_COMMAND} -p1 -i ${CMAKE_CURRENT_SOURCE_DIR}/../../patches/libgphoto2-jpegturbo.patch

    INSTALL_DIR ${EXTPREFIX_libgphoto2}
    CONFIGURE_COMMAND <SOURCE_DIR>/configure -prefix ${EXTPREFIX_libgphoto2}

    BUILD_COMMAND make
    INSTALL_COMMAND make install
    UPDATE_COMMAND ""
    BUILD_IN_SOURCE 1
    ALWAYS 0
)
