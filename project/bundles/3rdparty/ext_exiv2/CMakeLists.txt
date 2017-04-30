# Script to build Exiv2 for digiKam bundle.
#
# Copyright (c) 2015-2017, Gilles Caulier, <caulier dot gilles at gmail dot com>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.
#

set(PREFIX_ext_exiv2 "${EXTPREFIX}")

set(Exiv2_Conf -DEXIV2_ENABLE_SHARED=ON
               -DEXIV2_ENABLE_XMP=ON
               -DEXIV2_ENABLE_LIBXMP=ON
               -DEXIV2_ENABLE_PNG=ON
               -DEXIV2_ENABLE_NLS=OFF
               -DEXIV2_ENABLE_PRINTUCS2=ON
               -DEXIV2_ENABLE_LENSDATA=ON
               -DEXIV2_ENABLE_COMMERCIAL=OFF
               -DEXIV2_ENABLE_BUILD_SAMPLES=OFF
               -DEXIV2_ENABLE_BUILD_PO=OFF
               -DEXIV2_ENABLE_VIDEO=OFF
               -DEXIV2_ENABLE_WEBREADY=OFF
               -DEXIV2_ENABLE_CURL=OFF
               -DEXIV2_ENABLE_SSH=OFF
)

JoinListAsString("${Exiv2_Conf}" " " BASH_OPTIONS)

if(MINGW)

    ExternalProject_Add(ext_exiv2
        DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}

        # To use official release tarball
        URL http://www.exiv2.org/builds/exiv2-0.26-trunk.tar.gz
        URL_MD5 a171314cbd6535a356c8a7297ea8c5e7

        # To use current implementation from SVN

        #SVN_REPOSITORY svn://dev.exiv2.org/svn/trunk

        CONFIGURE_COMMAND cd <SOURCE_DIR>/exiv2-trunk && 
                          ./bootstrap.mxe ${MXE_BUILDROOT} RelWithDebInfo ${BASH_OPTIONS}

        BUILD_COMMAND cd <SOURCE_DIR>/exiv2-trunk/build && $(MAKE) -j

        INSTALL_COMMAND cd <SOURCE_DIR>/exiv2-trunk/build && $(MAKE) install/fast

        BUILD_IN_SOURCE 1

        UPDATE_COMMAND ""
        ALWAYS 0
    )


elseif(APPLE)

    ExternalProject_Add(ext_exiv2
        DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}

        # To use official release tarball

        URL http://www.exiv2.org/builds/exiv2-0.26-trunk.tar.gz
        URL_MD5 a171314cbd6535a356c8a7297ea8c5e7

        # To use current implementation from SVN

        #SVN_REPOSITORY svn://dev.exiv2.org/svn/trunk

        CONFIGURE_COMMAND cp -f ${CMAKE_CURRENT_SOURCE_DIR}/../../../../bootstrap.macports <SOURCE_DIR>/. &&
                          <SOURCE_DIR>/bootstrap.macports ${PREFIX_ext_exiv2} RelWithDebInfo x86_64 ${BASH_OPTIONS}

        BUILD_COMMAND cd <SOURCE_DIR>/build && $(MAKE)

        INSTALL_COMMAND cd <SOURCE_DIR>/build && $(MAKE) install/fast

        BUILD_IN_SOURCE 1

        UPDATE_COMMAND ""
        ALWAYS 0
    )

else() # Linux

    ExternalProject_Add(ext_exiv2
        DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}

        # To use official release tarball

        URL http://www.exiv2.org/builds/exiv2-0.26-trunk.tar.gz
        URL_MD5 a171314cbd6535a356c8a7297ea8c5e7

        # To use current implementation from SVN

        #SVN_REPOSITORY svn://dev.exiv2.org/svn/trunk

        CONFIGURE_COMMAND cd <SOURCE_DIR>/exiv2-trunk &&
                   $(CMAKE_COMMAND) . -DCMAKE_INSTALL_PREFIX=${PREFIX_ext_exiv2}
                   -DCMAKE_BUILD_TYPE=${GLOBAL_BUILD_TYPE}
                   -DICONV_INCLUDE_DIR=${PREFIX_ext_exiv2}/include
                   ${Exiv2_Conf}
                   ${GLOBAL_PROFILE}

        BUILD_COMMAND cd <SOURCE_DIR>/exiv2-trunk && $(MAKE)

        INSTALL_COMMAND cd <SOURCE_DIR>/exiv2-trunk && $(MAKE) install/fast

        UPDATE_COMMAND ""
        ALWAYS 0
    )

endif()
