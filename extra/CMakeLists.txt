#
# Copyright (c) 2010-2014, Gilles Caulier, <caulier dot gilles at gmail dot com>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.

find_package(KDE4 REQUIRED)
include(MacroOptionalAddSubdirectory)

if(${ENABLE_PRIVATE_SHAREDLIBS})

    # from kdegraphics/libs
    add_subdirectory(libkipi)
    add_subdirectory(libkexiv2)
    add_subdirectory(libkdcraw)
    add_subdirectory(libkface)
    MACRO_OPTIONAL_ADD_SUBDIRECTORY(libksane)

    # from extragear/libs
    add_subdirectory(libkgeomap)
    MACRO_OPTIONAL_ADD_SUBDIRECTORY(libmediawiki)
    MACRO_OPTIONAL_ADD_SUBDIRECTORY(libkvkontakte)

endif()

add_subdirectory(kipi-plugins)
