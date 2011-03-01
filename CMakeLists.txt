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

# make sure that the FindXXX modules of the local libraries are found
SET(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH}
        ${CMAKE_SOURCE_DIR}/extra/libkipi/cmake/modules
        ${CMAKE_SOURCE_DIR}/extra/libkdcraw/cmake/modules
        ${CMAKE_SOURCE_DIR}/extra/libkexiv2/cmake/modules
        ${CMAKE_SOURCE_DIR}/extra/libkface/cmake/modules
        ${CMAKE_SOURCE_DIR}/extra/libkmap/cmake/modules

        ${CMAKE_SOURCE_DIR}/cmake/modules
   )

SET(KIPI_LOCAL_DIR extra/libkipi)
SET(KEXIV2_LOCAL_DIR extra/libkexiv2)
SET(KDCRAW_LOCAL_DIR extra/libkdcraw)
SET(KFACE_LOCAL_DIR extra/libkface)
SET(KMAP_LOCAL_DIR extra/libkmap)
SET(KSANE_LOCAL_DIR extra/libksane)

ADD_SUBDIRECTORY(extra)
ADD_SUBDIRECTORY(core)
ADD_SUBDIRECTORY(doc)

