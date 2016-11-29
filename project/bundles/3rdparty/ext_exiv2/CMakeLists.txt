# Script to build Exiv2 for digiKam bundle.
#
# Copyright (c) 2015-2016, Gilles Caulier, <caulier dot gilles at gmail dot com>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.
#

SET(PREFIX_ext_exiv2 "${EXTPREFIX}")

if(MINGW)

    ExternalProject_Add(ext_exiv2
        DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}

        # To use official release tarball

        #URL http://www.exiv2.org/exiv2-0.25.tar.gz
        #URL_MD5 258d4831b30f75a01e0234065c6c2806

        # To use current implementation from SVN

        SVN_REPOSITORY svn://dev.exiv2.org/svn/trunk
        PATCH_COMMAND ${PATCH_COMMAND} -p0 -i ${CMAKE_CURRENT_SOURCE_DIR}/exiv2-trunk.patch

        INSTALL_DIR ${PREFIX_ext_exiv2}
        CONFIGURE_COMMAND <SOURCE_DIR>/make config
                  COMMAND <SOURCE_DIR>/configure --prefix=${PREFIX_ext_exiv2}
                                                 ${GLOBAL_AUTOMAKE_PROFILE}
                                                 --disable-visibility
                                                 --disable-nls
                                                 --with-expat
                                                 --disable-rpath
                                                 --with-libiconv-prefix=${PREFIX_ext_exiv2}/include

        UPDATE_COMMAND ""
        ALWAYS 0
    )


elseif(APPLE)

    ExternalProject_Add(ext_exiv2
        DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}

        # To use official release tarball

        #URL http://www.exiv2.org/exiv2-0.25.tar.gz
        #URL_MD5 258d4831b30f75a01e0234065c6c2806

        # To use current implementation from SVN

        SVN_REPOSITORY svn://dev.exiv2.org/svn/trunk

        PATCH_COMMAND ${PATCH_COMMAND} -p0 -i ${CMAKE_CURRENT_SOURCE_DIR}/exiv2-trunk.patch &&
                      ${PATCH_COMMAND} -p0 -i ${CMAKE_CURRENT_SOURCE_DIR}/exiv2-config-macos.patch

        CONFIGURE_COMMAND COMMAND <SOURCE_DIR>/bootstrap.macports ${PREFIX_ext_exiv2} debug x86_64

        BUILD_COMMAND cd <SOURCE_DIR>/build.cmake && make -j

        INSTALL_COMMAND cd <SOURCE_DIR>/build.cmake && make install/fast

        BUILD_IN_SOURCE 1

        UPDATE_COMMAND ""
        ALWAYS 0
    )

else() # Linux

    ExternalProject_Add(ext_exiv2
        DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}

        # To use official release tarball

        #URL http://www.exiv2.org/exiv2-0.25.tar.gz
        #URL_MD5 258d4831b30f75a01e0234065c6c2806

        # To use current implementation from SVN

        SVN_REPOSITORY svn://dev.exiv2.org/svn/trunk
        PATCH_COMMAND ${PATCH_COMMAND} -p0 -i ${CMAKE_CURRENT_SOURCE_DIR}/exiv2-trunk.patch

        INSTALL_DIR ${PREFIX_ext_exiv2}
        CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${PREFIX_ext_exiv2}
                   -DCMAKE_BUILD_TYPE=${GLOBAL_BUILD_TYPE}
                   ${GLOBAL_PROFILE}
                   -DEXIV2_ENABLE_BUILD_SAMPLES=OFF
                   -DEXIV2_ENABLE_BUILD_PO=OFF
                   -DEXIV2_ENABLE_NLS=OFF
                   -DICONV_INCLUDE_DIR=${PREFIX_ext_exiv2}/include

        UPDATE_COMMAND ""
        ALWAYS 0
    )

endif()
