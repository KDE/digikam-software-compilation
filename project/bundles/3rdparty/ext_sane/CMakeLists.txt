# Script to build sane backends for digiKam bundle.
#
# Copyright (c) 2015-2017, Gilles Caulier, <caulier dot gilles at gmail dot com>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.
#

SET(EXTPREFIX_sane "${EXTPREFIX}")

ExternalProject_Add(ext_sane
    DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}
    URL https://alioth.debian.org/frs/download.php/file/4146/sane-backends-1.0.25.tar.gz
    URL_MD5 f9ed5405b3c12f07c6ca51ee60225fe7

    INSTALL_DIR ${EXTPREFIX_sane}
    CONFIGURE_COMMAND <SOURCE_DIR>/configure -prefix ${EXTPREFIX_sane}
    UPDATE_COMMAND ""
    BUILD_IN_SOURCE 1
    ALWAYS 0
)
