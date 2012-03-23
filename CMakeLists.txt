# ===========================================================
#
# This file is a part of digiKam project
# <a href="http://www.digikam.org">http://www.digikam.org</a>
#
# @date   2010-12-11
# @brief  digiKam Software Collection
#
# @author Copyright (C) 2010-2012 by Gilles Caulier
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

CMAKE_MINIMUM_REQUIRED(VERSION 2.8.4)

IF(POLICY CMP0011)
   CMAKE_POLICY(SET CMP0017 NEW)
ENDIF(POLICY CMP0011)

PROJECT(digikam-sc)

OPTION(DIGIKAMSC_COMPILE_PO              "Build translations files (default=OFF)"                                                OFF)
OPTION(DIGIKAMSC_COMPILE_DOC             "Build handbook files (default=OFF)"                                                    OFF)
OPTION(DIGIKAMSC_USE_PRIVATE_KDEGRAPHICS "Build local kdegraphics librairies instead to use distributed KDE files (default=OFF)" OFF)

IF(KDE4_BUILD_TESTS)
    INCLUDE(CTest)
    ENABLE_TESTING()
ENDIF(KDE4_BUILD_TESTS)

FIND_PACKAGE(KDE4 REQUIRED)
INCLUDE(KDE4Defaults)
INCLUDE(MacroLibrary)
INCLUDE(MacroOptionalAddSubdirectory)

IF(DEFINED DIGIKAMSC_COMPILE_PO)
    SET_PROPERTY(GLOBAL PROPERTY ALLOW_DUPLICATE_CUSTOM_TARGETS 1)
ENDIF(DEFINED DIGIKAMSC_COMPILE_PO)

# If building for KDE<4.6.95, we need to build some parts of KDE-graphics
# by ourselves, because we depend on newer versions. If you want
# to force building of these libraries, specify -DDIGIKAMSC_USE_PRIVATE_KDEGRAPHICS:BOOL=1
# as an argument to CMake.
IF(NOT DEFINED DIGIKAMSC_USE_PRIVATE_KDEGRAPHICS)
    IF(${KDE_VERSION} VERSION_LESS "4.6.95")
        SET(DIGIKAMSC_USE_PRIVATE_KDEGRAPHICS 1)
    ELSE()
        SET(DIGIKAMSC_USE_PRIVATE_KDEGRAPHICS 0)
    ENDIF()
ENDIF()

# Make sure that the FindXXX modules of the local libraries are found
IF(${DIGIKAMSC_USE_PRIVATE_KDEGRAPHICS})
    # prepend our own FindXXX modules to CMAKE_MODULE_PATH
    SET(CMAKE_MODULE_PATH
            ${CMAKE_SOURCE_DIR}/extra/libkexiv2/cmake/modules
            ${CMAKE_SOURCE_DIR}/extra/libkdcraw/cmake/modules
            ${CMAKE_MODULE_PATH}
        )
ENDIF()

# prepend our own FindXXX modules to CMAKE_MODULE_PATH
SET(CMAKE_MODULE_PATH
        ${CMAKE_SOURCE_DIR}/extra/libkgeomap/cmake/modules
        ${CMAKE_SOURCE_DIR}/extra/libmediawiki/cmake/modules
        ${CMAKE_SOURCE_DIR}/extra/libkface/cmake/modules
        ${CMAKE_SOURCE_DIR}/extra/libkvkontakte/cmake/modules
        ${CMAKE_SOURCE_DIR}/cmake/modules
        ${CMAKE_MODULE_PATH}
    )

IF(${DIGIKAMSC_USE_PRIVATE_KDEGRAPHICS})
    SET(KIPI_LOCAL_DIR extra/libkipi)
    SET(KEXIV2_LOCAL_DIR extra/libkexiv2)
    SET(KDCRAW_LOCAL_DIR extra/libkdcraw)
    SET(KSANE_LOCAL_DIR extra/libksane)
ENDIF()

SET(KFACE_LOCAL_DIR extra/libkface)
SET(KGEOMAP_LOCAL_DIR extra/libkgeomap)
SET(MEDIAWIKI_LOCAL_DIR extra/libmediawiki)
SET(LIBKVKONTAKTE_LOCAL_DIR extra/libkvkontakte)

ADD_SUBDIRECTORY(extra)
ADD_SUBDIRECTORY(core)

IF(DEFINED DIGIKAMSC_COMPILE_DOC)
    MACRO_OPTIONAL_ADD_SUBDIRECTORY(doc)
ENDIF(DEFINED DIGIKAMSC_COMPILE_DOC)

IF(DEFINED DIGIKAMSC_COMPILE_PO)
    FIND_PACKAGE(Msgfmt REQUIRED)
    FIND_PACKAGE(Gettext REQUIRED)
    ADD_SUBDIRECTORY(po)
ENDIF(DEFINED DIGIKAMSC_COMPILE_PO)
