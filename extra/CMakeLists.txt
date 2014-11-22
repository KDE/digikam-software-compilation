#
# Copyright (c) 2010-2014, Gilles Caulier, <caulier dot gilles at gmail dot com>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.

if(ENABLE_COMPILE_LIBKEXIV2)
    add_subdirectory(libkexiv2)
endif()

if(ENABLE_COMPILE_LIBKDCRAW)
    add_subdirectory(libkdcraw)
endif()

if(ENABLE_COMPILE_LIBKIPI)
    add_subdirectory(libkipi)
endif()

if(ENABLE_COMPILE_LIBKGEOMAP)
    ECM_OPTIONAL_ADD_SUBDIRECTORY(libkgeomap)
endif()

if(ENABLE_COMPILE_LIBKFACE)
    ECM_OPTIONAL_ADD_SUBDIRECTORY(libkface)
endif()

if(ENABLE_COMPILE_LIBKSANE)
    ECM_OPTIONAL_ADD_SUBDIRECTORY(libksane)
endif()

if(ENABLE_COMPILE_LIBMEDIAWIKI)
    ECM_OPTIONAL_ADD_SUBDIRECTORY(libmediawiki)
endif()

if(ENABLE_COMPILE_LIBKVKONTAKTE)
    ECM_OPTIONAL_ADD_SUBDIRECTORY(libkvkontakte)
endif()

if(ENABLE_COMPILE_PLUGINS)
    add_subdirectory(kipi-plugins)
endif()
