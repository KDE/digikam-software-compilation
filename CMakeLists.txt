# ===========================================================
#
# This file is a part of digiKam project
# <a href="http://www.digikam.org">http://www.digikam.org</a>
#
# @date   2010-12-11
# @brief  digiKam Software Collection
#
# @author Copyright (C) 2010-2011 by Gilles Caulier
#         <a href="mailto:caulier dot gilles at gmail dot com">caulier dot gilles at gmail dot com</a>
#
# This program is free software; you can redistribute it
# and/or modify it under the terms of the GNU General
# Public License as published by the Free Software Foundation;
# either version 2, or (at your option)
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# ============================================================

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

PROJECT(digikam-sc)

IF(KDE4_BUILD_TESTS)
    INCLUDE(CTest)
    ENABLE_TESTING()
ENDIF(KDE4_BUILD_TESTS)
#FIND_PACKAGE(KDE4 REQUIRED)
# Added for the po/ folder 
#set_property(GLOBAL PROPERTY ALLOW_DUPLICATE_CUSTOM_TARGETS 1)

# make sure that the FindXXX modules of the local libraries are found
IF (${KDE_VERSION} VERSION_LESS "4.6.95")
	SET(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH}
        	${CMAKE_SOURCE_DIR}/extra/libkdcraw/cmake/modules
        	${CMAKE_SOURCE_DIR}/extra/libkface/cmake/modules
        	${CMAKE_SOURCE_DIR}/extra/libkgeomap/cmake/modules
        	${CMAKE_SOURCE_DIR}/extra/libmediawiki/cmake/modules

        	${CMAKE_SOURCE_DIR}/cmake/modules
		)
ELSE()
	SET(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH}
		${CMAKE_SOURCE_DIR}/extra/libkgeomap/cmake/modules
		${CMAKE_SOURCE_DIR}/extra/libmediawiki/cmake/modules
		${CMAKE_SOURCE_DIR}/extra/libkface/cmake/modules

		${CMAKE_SOURCE_DIR}/cmake/modules
		)
ENDIF()


IF (${KDE_VERSION} VERSION_LESS "4.6.95")
SET(KIPI_LOCAL_DIR extra/libkipi)
SET(KEXIV2_LOCAL_DIR extra/libkexiv2)
SET(KDCRAW_LOCAL_DIR extra/libkdcraw)
SET(KSANE_LOCAL_DIR extra/libksane)
ENDIF()
SET(KFACE_LOCAL_DIR extra/libkface)
SET(KGEOMAP_LOCAL_DIR extra/libkgeomap)
SET(MEDIAWIKI_LOCAL_DIR extra/libmediawiki)

ADD_SUBDIRECTORY(extra)
ADD_SUBDIRECTORY(core)
ADD_SUBDIRECTORY(doc)

#find_package(Msgfmt REQUIRED)
#find_package(Gettext REQUIRED)
#add_subdirectory( po )

