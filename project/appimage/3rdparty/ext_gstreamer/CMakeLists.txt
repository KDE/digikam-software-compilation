# Script to build GStreamer for digiKam bundle.
#
# Copyright (c) 2015-2016, Gilles Caulier, <caulier dot gilles at gmail dot com>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.
#

SET(PREFIX_ext_gstreamer "${EXTPREFIX}")

ExternalProject_add(ext_gst-core
        DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}
        URL https://gstreamer.freedesktop.org/src/gstreamer/gstreamer-1.10.1.tar.xz
        URL_MD5 2c0cc6907aed5ea8005a8f332e34d92f
        CONFIGURE_COMMAND <SOURCE_DIR>/./configure
                  --prefix=${PREFIX_ext_gstreamer}
                  --disable-tests
                  --disable-valgrind
                  --disable-benchmarks
                  --disable-check

        BUILD_COMMAND make install
        INSTALL_COMMAND ""
        INSTALL_DIR ${PREFIX_ext_gstreamer}

        UPDATE_COMMAND ""
        ALWAYS 0
        BUILD_IN_SOURCE 1
)

ExternalProject_add(ext_gst-base
        DEPENDS ext_gst-core
        URL https://gstreamer.freedesktop.org/src/gst-plugins-base/gst-plugins-base-1.10.1.tar.xz
        URL_MD5 eb03953ff239b53a7d69a604edbe5c8c
        CONFIGURE_COMMAND <SOURCE_DIR>/./configure
                  --prefix=${PREFIX_ext_gstreamer}
                  --disable-examples
                  --disable-valgrind
                  --disable-audioconvert
                  --disable-audiotestsrc
                  --disable-encoding
                  --disable-videoconvert
                  --disable-tcp
                  --disable-videotestsrc
                  --disable-pango

        BUILD_COMMAND make install
        INSTALL_COMMAND ""
        INSTALL_DIR ${PREFIX_ext_gstreamer}

        UPDATE_COMMAND ""
        ALWAYS 0
        BUILD_IN_SOURCE 1
)

ExternalProject_add(ext_gst-good
        DEPENDS ext_gst-core
        URL https://gstreamer.freedesktop.org/src/gst-plugins-good/gst-plugins-good-1.10.1.tar.xz
        URL_MD5 7d24b1412d49fa7bab763b35f4640abd
        CONFIGURE_COMMAND <SOURCE_DIR>/./configure
                  --prefix=${PREFIX_ext_gstreamer}
                  --disable-examples
                  --disable-valgrind
                  --disable-debugutils
                  --disable-rtp
                  --disable-rtpmanager
                  --disable-jpeg
                  --disable-libcaca
                  --disable-libpng

        BUILD_COMMAND make install
        INSTALL_COMMAND ""
        INSTALL_DIR ${PREFIX_ext_gstreamer}

        UPDATE_COMMAND ""
        ALWAYS 0
        BUILD_IN_SOURCE 1
)

ExternalProject_add(ext_gst-ugly
        DEPENDS ext_gst-core
        URL https://gstreamer.freedesktop.org/src/gst-plugins-ugly/gst-plugins-ugly-1.10.1.tar.xz
        URL_MD5 646ab511bc8e56425e63d3fc4812e582
        CONFIGURE_COMMAND <SOURCE_DIR>/./configure
                  --prefix=${PREFIX_ext_gstreamer}
                  --disable-examples
                  --disable-valgrind
                  --disable-lame
                  --disable-mpeg2dec
                  --disable-twolame
                  --disable-dvdlpcmdec
                  --disable-dvdsub

        BUILD_COMMAND make install
        INSTALL_COMMAND ""
        INSTALL_DIR ${PREFIX_ext_gstreamer}

        UPDATE_COMMAND ""
        ALWAYS 0
        BUILD_IN_SOURCE 1
)
