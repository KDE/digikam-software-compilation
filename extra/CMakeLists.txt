#
# Copyright (c) 2010-2015, Gilles Caulier, <caulier dot gilles at gmail dot com>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.

if(DIGIKAMSC_COMPILE_LIBKIPI)
    add_subdirectory(libkipi)
endif()

if(DIGIKAMSC_COMPILE_LIBKSANE)
    ECM_OPTIONAL_ADD_SUBDIRECTORY(libksane)
endif()

if(DIGIKAMSC_COMPILE_LIBMEDIAWIKI)
    ECM_OPTIONAL_ADD_SUBDIRECTORY(libmediawiki)
endif()

if(DIGIKAMSC_COMPILE_LIBKVKONTAKTE)
    ECM_OPTIONAL_ADD_SUBDIRECTORY(libkvkontakte)
endif()

if(DIGIKAMSC_COMPILE_KIPIPLUGINS)
    add_subdirectory(kipi-plugins)
endif()
