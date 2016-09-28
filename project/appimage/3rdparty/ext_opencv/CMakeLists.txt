SET(EXTPREFIX_opencv "${EXTPREFIX}" )
ExternalProject_Add( ext_opencv
    DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}
    URL https://github.com/Itseez/opencv/archive/3.1.0.zip

    INSTALL_DIR ${EXTPREFIX_opencv}
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${EXTPREFIX_opencv} -DCMAKE_BUILD_TYPE=${GLOBAL_BUILD_TYPE} ${GLOBAL_PROFILE}

    UPDATE_COMMAND ""
    ALWAYS 0
)
