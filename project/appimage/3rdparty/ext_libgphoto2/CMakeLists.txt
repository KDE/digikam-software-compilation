SET(EXTPREFIX_libgphoto2 "${EXTPREFIX}" )
ExternalProject_Add( ext_libgphoto2
    DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}
    URL http://downloads.sourceforge.net/project/gphoto/libgphoto/2.5.10/libgphoto2-2.5.10.tar.bz2

    INSTALL_DIR ${EXTPREFIX_libgphoto2}
    CONFIGURE_COMMAND <SOURCE_DIR>/configure -prefix ${EXTPREFIX_libgphoto2}

    BUILD_COMMAND make
    INSTALL_COMMAND make install
    UPDATE_COMMAND ""
    BUILD_IN_SOURCE 1
    ALWAYS 0
)
