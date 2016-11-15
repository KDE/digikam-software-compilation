# Script to build jasperlib for digiKam bundle.
#
# Copyright (c) 2015-2016, Gilles Caulier, <caulier dot gilles at gmail dot com>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.
#

SET(PREFIX_ext_jasper "${EXTPREFIX}")

ExternalProject_Add(ext_jasper
    DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}
    URL http://www.ece.uvic.ca/~frodo/jasper/software/jasper-1.900.28.tar.gz
    URL_MD5 979fd58a439ccaba8eb3b806d7e6a87e

    CONFIGURE_COMMAND <SOURCE_DIR>/configure --prefix=${PREFIX_ext_jasper} ${GLOBAL_AUTOMAKE_PROFILE} --disable-opengl
    BUILD_COMMAND make
    INSTALL_COMMAND make install

    UPDATE_COMMAND ""
    ALWAYS 0
)
