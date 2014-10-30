# ===========================================================
#
# This file is a part of digiKam project
# <a href="http://www.digikam.org">http://www.digikam.org</a>
#
# @date   2010-12-11
# @brief  digiKam Software Collection
#
# @author Copyright (C) 2010-2014 by Gilles Caulier
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

FIND_PACKAGE(KDE4 REQUIRED)
INCLUDE(MacroOptionalAddSubdirectory)

IF(${ENABLE_PRIVATE_SHAREDLIBS})
    # from kdegraphics/libs
    ADD_SUBDIRECTORY(libkipi)
    ADD_SUBDIRECTORY(libkexiv2)
    ADD_SUBDIRECTORY(libkdcraw)
    ADD_SUBDIRECTORY(libkface)
    MACRO_OPTIONAL_ADD_SUBDIRECTORY(libksane)

    # from extragear/libs
    ADD_SUBDIRECTORY(libkgeomap)
    MACRO_OPTIONAL_ADD_SUBDIRECTORY(libmediawiki)
    MACRO_OPTIONAL_ADD_SUBDIRECTORY(libkvkontakte)
ENDIF()

ADD_SUBDIRECTORY(kipi-plugins)
