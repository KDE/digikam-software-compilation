# Script to build gcc for digiKam bundle.
#
# Copyright (c) 2015-2016, Gilles Caulier, <caulier dot gilles at gmail dot com>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.
#

SET(PREFIX_ext_gcc "${EXTPREFIX}")

ExternalProject_add(gmp
	DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}
	URL https://ftp.gnu.org/gnu/gmp/gmp-6.1.1.tar.xz
	URL_MD5 e70e183609244a332d80529e7e155a35
	CONFIGURE_COMMAND <SOURCE_DIR>/./configure --enable-cxx --prefix=${PREFIX_ext_gcc}
	BUILD_COMMAND  <SOURCE_DIR>/make install
	INSTALL_COMMAND ""
	INSTALL_DIR ${PREFIX_ext_gcc}

	UPDATE_COMMAND ""
	ALWAYS 0
	BUILD_IN_SOURCE 1
)

ExternalProject_add(gcc
	DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}
	URL https://ftp.gnu.org/gnu/gcc/gcc-5.4.0/gcc-5.4.0.tar.gz
	URL_MD5 f2b4d5a580061711e68f0f506e402e1c
	CONFIGURE_COMMAND <SOURCE_DIR>/./configure --with-gmp=${PREFIX_ext_gcc} --prefix=${PREFIX_ext_gcc} --disable-werror --disable-multilib
	BUILD_COMMAND  <SOURCE_DIR>/make
	INSTALL_COMMAND <SOURCE_DIR>/make install
	INSTALL_DIR ${PREFIX_ext_gcc}

	UPDATE_COMMAND ""
	ALWAYS 0
	BUILD_IN_SOURCE 1
)

