# Script to build OpenCV for digiKam bundle.
#
# Copyright (c) 2015-2016, Gilles Caulier, <caulier dot gilles at gmail dot com>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.
#

SET(EXTPREFIX_opencv "${EXTPREFIX}" )

if(MINGW)

    ExternalProject_Add(ext_opencv
        DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}

        GIT_REPOSITORY https://github.com/opencv/opencv.git
        GIT_TAG 3.1.0

#        PATCH_COMMAND ${PATCH_COMMAND} -p1 -i ${CMAKE_CURRENT_SOURCE_DIR}/lib-install-name-macports.patch

        CONFIGURE_COMMAND cp ${CMAKE_CURRENT_SOURCE_DIR}/../../../../bootstrap.mxe <SOURCE_DIR>/. &&
                          <SOURCE_DIR>/bootstrap.mxe ${EXTPREFIX_opencv} relwithdebinfo x86_64 "-DBUILD_EXAMPLES=OFF -DBUILD_TESTS=OFF -DBUILD_DOCS=OFF -DBUILD_PERF_TESTS=OFF -DBUILD_NEW_PYTHON_SUPPORT=OFF -DOPENCV_BUILD_3RDPARTY_LIBS=OFF -DINSTALL_C_EXAMPLES=OFF -DINSTALL_PYTHON_EXAMPLES=OFF -DWITH_1394=OFF -DWITH_VTK=OFF -DWITH_CUDA=OFF -DWITH_EIGEN=OFF -DWITH_FFMPEG=OFF -DWITH_GSTREAMER=OFF -DWITH_GTK=OFF -DWITH_IPP=OFF -DWITH_JASPER=OFF -DWITH_JPEG=OFF -DWITH_OPENEXR=OFF -DWITH_OPENNI=OFF -DWITH_PNG=OFF -DWITH_PVAPI=OFF -DWITH_QT=OFF -DWITH_QUICKTIME=OFF -DWITH_QT_OPENGL=OFF -DWITH_TBB=OFF -DWITH_TIFF=OFF -DWITH_UNICAP=OFF -DWITH_V4L=OFF -DWITH_VIDEOINPUT=OFF -DWITH_XINE=OFF -DWITH_OPENCL=OFF -DWITH_GPHOTO2=OFF -Wno-dev"

        BUILD_COMMAND cd <SOURCE_DIR>/build && make -j

        INSTALL_COMMAND cd <SOURCE_DIR>/build && make install/fast

        BUILD_IN_SOURCE 1

        UPDATE_COMMAND ""
        ALWAYS 0
    )

elseif(APPLE)

    ExternalProject_Add(ext_opencv
        DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}

        URL https://github.com/Itseez/opencv/archive/3.1.0.zip
        URL_MD5 6082ee2124d4066581a7386972bfd52a

        PATCH_COMMAND ${PATCH_COMMAND} -p1 -i ${CMAKE_CURRENT_SOURCE_DIR}/lib-install-name-macports.patch

        CONFIGURE_COMMAND cp ${CMAKE_CURRENT_SOURCE_DIR}/../../../../bootstrap.macports <SOURCE_DIR>/. &&
                          <SOURCE_DIR>/bootstrap.macports ${EXTPREFIX_opencv} relwithdebinfo x86_64 "-DBUILD_EXAMPLES=OFF -DBUILD_TESTS=OFF -DBUILD_DOCS=OFF -DBUILD_PERF_TESTS=OFF -DBUILD_NEW_PYTHON_SUPPORT=OFF -DOPENCV_BUILD_3RDPARTY_LIBS=OFF -DINSTALL_C_EXAMPLES=OFF -DINSTALL_PYTHON_EXAMPLES=OFF -DWITH_1394=OFF -DWITH_VTK=OFF -DWITH_CUDA=OFF -DWITH_EIGEN=OFF -DWITH_FFMPEG=OFF -DWITH_GSTREAMER=OFF -DWITH_GTK=OFF -DWITH_IPP=OFF -DWITH_JASPER=OFF -DWITH_JPEG=OFF -DWITH_OPENEXR=OFF -DWITH_OPENNI=OFF -DWITH_PNG=OFF -DWITH_PVAPI=OFF -DWITH_QT=OFF -DWITH_QUICKTIME=OFF -DWITH_QT_OPENGL=OFF -DWITH_TBB=OFF -DWITH_TIFF=OFF -DWITH_UNICAP=OFF -DWITH_V4L=OFF -DWITH_VIDEOINPUT=OFF -DWITH_XINE=OFF -DWITH_OPENCL=OFF -DWITH_GPHOTO2=OFF -Wno-dev"

        BUILD_COMMAND cd <SOURCE_DIR>/build && make -j

        INSTALL_COMMAND cd <SOURCE_DIR>/build && make install/fast

        BUILD_IN_SOURCE 1

        UPDATE_COMMAND ""
        ALWAYS 0
    )

else() #Linux

    ExternalProject_Add(ext_opencv
        DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}

        URL https://github.com/Itseez/opencv/archive/3.1.0.zip
        URL_MD5 6082ee2124d4066581a7386972bfd52a

        INSTALL_DIR ${EXTPREFIX_opencv}

        CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${EXTPREFIX_opencv}
                   -DCMAKE_BUILD_TYPE=${GLOBAL_BUILD_TYPE}
                   ${GLOBAL_PROFILE}
                   -DBUILD_EXAMPLES=OFF
                   -DBUILD_TESTS=OFF
                   -DBUILD_DOCS=OFF
                   -DBUILD_PERF_TESTS=OFF
                   -DBUILD_NEW_PYTHON_SUPPORT=OFF
                   -DOPENCV_BUILD_3RDPARTY_LIBS=OFF
                   -DINSTALL_C_EXAMPLES=OFF
                   -DINSTALL_PYTHON_EXAMPLES=OFF
                   -DWITH_1394=OFF
                   -DWITH_VTK=OFF
                   -DWITH_CUDA=OFF
                   -DWITH_EIGEN=OFF
                   -DWITH_FFMPEG=OFF
                   -DWITH_GSTREAMER=OFF
                   -DWITH_GTK=OFF
                   -DWITH_IPP=OFF
                   -DWITH_JASPER=OFF
                   -DWITH_JPEG=OFF
                   -DWITH_OPENEXR=OFF
                   -DWITH_OPENNI=OFF
                   -DWITH_PNG=OFF
                   -DWITH_PVAPI=OFF
                   -DWITH_QT=OFF
                   -DWITH_QUICKTIME=OFF
                   -DWITH_QT_OPENGL=OFF
                   -DWITH_TBB=OFF
                   -DWITH_TIFF=OFF
                   -DWITH_UNICAP=OFF
                   -DWITH_V4L=OFF
                   -DWITH_VIDEOINPUT=OFF
                   -DWITH_XINE=OFF
                   -DWITH_OPENCL=OFF
                   -DWITH_GPHOTO2=OFF

        UPDATE_COMMAND ""
        ALWAYS 0
    )

endif()