#
# Copyright (c) 2010-2014, Gilles Caulier, <caulier dot gilles at gmail dot com>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.

cmake_minimum_required(VERSION 2.8.4)

if(POLICY CMP0011)
   cmake_policy(SET CMP0017 NEW)
endif()

project(digikam-sc)

find_package(KDE4 REQUIRED)
include(KDE4Defaults)
include(MacroLibrary)
include(MacroOptionalAddSubdirectory)

# COMPILATION OPTIONS MANAGEMENT ###########################################################################################################

# doc and translations options

option(DIGIKAMSC_CHECKOUT_PO             "Checkout translations files from KDE repositories (default=OFF)"                        OFF)
option(DIGIKAMSC_COMPILE_PO              "Build translations files (default=ON)"                                                  ON)
option(DIGIKAMSC_COMPILE_DOC             "Build handbook files (default=ON)"                                                      ON)

# shared libs options

option(DIGIKAMSC_COMPILE_LIBKIPI         "Build local libkipi library instead of using distributed files (default=OFF)"           OFF)
option(DIGIKAMSC_COMPILE_LIBKEXIV2       "Build local libkexiv2 library instead of using distributed files (default=OFF)"         OFF)
option(DIGIKAMSC_COMPILE_LIBKDCRAW       "Build local libkdcraw library instead of using distributed files (default=OFF)"         OFF)
option(DIGIKAMSC_COMPILE_LIBKSANE        "Build local libksane library instead of using distributed files (default=OFF)"          OFF)
option(DIGIKAMSC_COMPILE_LIBKFACE        "Build local libkface library instead of using distributed files (default=OFF)"          OFF)
option(DIGIKAMSC_COMPILE_LIBKGEOMAP      "Build local libkgeomap library instead of using distributed files (default=OFF)"        OFF)
option(DIGIKAMSC_COMPILE_LIBMEDIAWIKI    "Build local libmediawiki library instead of using distributed files (default=OFF)"      OFF)
option(DIGIKAMSC_COMPILE_LIBKVKONTAKTE   "Build local libkvkontakte library instead of using distributed files (default=OFF)"     OFF)

###########################################################################################################################################

MACRO_BOOL_TO_01(DIGIKAMSC_CHECKOUT_PO           ENABLE_CHECKOUT_PO)
MACRO_BOOL_TO_01(DIGIKAMSC_COMPILE_PO            ENABLE_COMPILE_PO)
MACRO_BOOL_TO_01(DIGIKAMSC_COMPILE_DOC           ENABLE_COMPILE_DOC)

MACRO_BOOL_TO_01(DIGIKAMSC_COMPILE_LIBKIPI       ENABLE_COMPILE_LIBKIPI)
MACRO_BOOL_TO_01(DIGIKAMSC_COMPILE_LIBKEXIV2     ENABLE_COMPILE_LIBKEXIV2)
MACRO_BOOL_TO_01(DIGIKAMSC_COMPILE_LIBKDCRAW     ENABLE_COMPILE_LIBKDCRAW)
MACRO_BOOL_TO_01(DIGIKAMSC_COMPILE_LIBKSANE      ENABLE_COMPILE_LIBKSANE)
MACRO_BOOL_TO_01(DIGIKAMSC_COMPILE_LIBKFACE      ENABLE_COMPILE_LIBKFACE)
MACRO_BOOL_TO_01(DIGIKAMSC_COMPILE_LIBKGEOMAP    ENABLE_COMPILE_LIBKGEOMAP)
MACRO_BOOL_TO_01(DIGIKAMSC_COMPILE_LIBMEDIAWIKI  ENABLE_COMPILE_LIBMEDIAWIKI)
MACRO_BOOL_TO_01(DIGIKAMSC_COMPILE_LIBKVKONTAKTE ENABLE_COMPILE_LIBKVKONTAKTE)

###########################################################################################################################################

if(ENABLE_CHECKOUT_PO)

    find_package(Ruby)

    if(RUBY_EXECUTABLE)
        message(STATUS "Extract translation files from KDE repositories. Please wait, it can take a while...")
        execute_process(COMMAND ${RUBY_EXECUTABLE} "${CMAKE_SOURCE_DIR}/project/release/fetch_l10n.rb"
                        WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}"
                        OUTPUT_QUIET
                        ERROR_QUIET)
        message(STATUS "Translation files extraction done.")
    else()
        message(STATUS "Could not find Ruby to extract translation files")
    endif()

endif()

if(ENABLE_COMPILE_PO AND NOT EXISTS ${CMAKE_SOURCE_DIR}/po/)

    message(STATUS "${CMAKE_SOURCE_DIR}/po/ dir do not exists. Translations compilation disabled...")

    if(NOT ENABLE_CHECKOUT_PO)
        message(STATUS "You can use DIGIKAMSC_CHECKOUT_PO option to extract po files from KDE repositories.")
    endif()

    set(ENABLE_COMPILE_PO 0)

endif()

if(ENABLE_COMPILE_PO)
    set_property(GLOBAL PROPERTY ALLOW_DUPLICATE_CUSTOM_TARGETS 1)
endif()

if(KDE4_BUILD_TESTS)
    include(CTest)
    ENABLE_TESTING()
endif()

############################################################################################################################################

message(STATUS "----------------------------------------------------------------------------------")
message(STATUS "Starting CMake configuration for: digiKam Software Collection")

if(ENABLE_COMPILE_LIBKIPI)
    message(STATUS "Local shared libkipi will be compiled.......... YES")
else()
    message(STATUS "Local shared libkipi will be compiled.......... NO")
endif()

if(ENABLE_COMPILE_LIBKEXIV2)
    message(STATUS "Local shared libkexiv2 will be compiled........ YES")
else()
    message(STATUS "Local shared libkexiv2 will be compiled........ NO")
endif()

if(ENABLE_COMPILE_LIBKDCRAW)
    message(STATUS "Local shared libkdcraw will be compiled........ YES")
else()
    message(STATUS "Local shared libkdcraw will be compiled........ NO")
endif()

if(ENABLE_COMPILE_LIBKSANE)
    message(STATUS "Local shared libksane will be compiled......... YES")
else()
    message(STATUS "Local shared libksane will be compiled......... NO")
endif()

if(ENABLE_COMPILE_LIBKFACE)
    message(STATUS "Local shared libkface will be compiled......... YES")
else()
    message(STATUS "Local shared libkface will be compiled......... NO")
endif()

if(ENABLE_COMPILE_LIBKGEOMAP)
    message(STATUS "Local shared libkgeomap will be compiled....... YES")
else()
    message(STATUS "Local shared libkgeomap will be compiled....... NO")
endif()

if(ENABLE_COMPILE_LIBMEDIAWIKI)
    message(STATUS "Local shared libmediawiki will be compiled..... YES")
else()
    message(STATUS "Local shared libmediawiki will be compiled..... NO")
endif()

if(ENABLE_COMPILE_LIBKVKONTAKTE)
    message(STATUS "Local shared libkvkontakte will be compiled.... YES")
else()
    message(STATUS "Local shared libkvkontakte will be compiled.... NO")
endif()

if(ENABLE_CHECKOUT_PO)
    message(STATUS "Extract translations files..................... YES")
else()
    message(STATUS "Extract translations files..................... NO")
endif()

if(ENABLE_COMPILE_PO)
    message(STATUS "Translations will be compiled.................. YES")
else()
    message(STATUS "Translations will be compiled.................. NO")
endif()

if(ENABLE_COMPILE_DOC)
    message(STATUS "Handbooks will be compiled..................... YES")
else()
    message(STATUS "Handbooks will be compiled..................... NO")
endif()

if(KDE4_BUILD_TESTS)
    message(STATUS "Tests code will be compiled.................... YES")
else()
    message(STATUS "Tests code will be compiled.................... NO")
endif()

############################################################################################################################################

# Make sure that the FindXXX modules of the local libraries are found and set compilation variables if necessary

set(CMAKE_MODULE_PATH
    ${CMAKE_SOURCE_DIR}/extra/libkgeomap/cmake/modules
    ${CMAKE_SOURCE_DIR}/extra/libmediawiki/cmake/modules
    ${CMAKE_SOURCE_DIR}/cmake/modules
    ${CMAKE_MODULE_PATH}
   )

if(ENABLE_COMPILE_LIBKIPI)
    set(KIPI_LOCAL_DIR extra/libkipi)
endif()

if(ENABLE_COMPILE_LIBKEXIV2)
    set(KEXIV2_LOCAL_DIR extra/libkexiv2)
endif()

if(ENABLE_COMPILE_LIBKFACE)
    set(KFACE_LOCAL_DIR extra/libkface)
endif()

if(ENABLE_COMPILE_LIBKSANE)
    set(KSANE_LOCAL_DIR extra/libksane)
endif()

if(ENABLE_COMPILE_LIBKDCRAW)
    set(CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/extra/libkdcraw/cmake/modules ${CMAKE_MODULE_PATH})
    set(KDCRAW_LOCAL_DIR extra/libkdcraw)
endif()

if(ENABLE_COMPILE_LIBKGEOMAP)
    set(KGEOMAP_LOCAL_DIR extra/libkgeomap)
endif()

if(ENABLE_COMPILE_LIBMEDIAWIKI)
    set(MEDIAWIKI_LOCAL_DIR extra/libmediawiki)
endif()

if(ENABLE_COMPILE_LIBKVKONTAKTE)
    set(CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake/modules/digikamsc-compile-libkvkontakte ${CMAKE_MODULE_PATH})
    set(LIBKVKONTAKTE_LOCAL_DIR extra/libkvkontakte)
endif()

############################################################################################################################################

add_subdirectory(extra)
add_subdirectory(core)

if(ENABLE_COMPILE_DOC)
    MACRO_OPTIONAL_ADD_SUBDIRECTORY(doc)
    MACRO_OPTIONAL_ADD_SUBDIRECTORY(doc-translated)
endif()

if(ENABLE_COMPILE_PO)
    find_package(Msgfmt  REQUIRED)
    find_package(Gettext REQUIRED)
    add_subdirectory(po)
endif()
