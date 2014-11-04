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

option(DIGIKAMSC_CHECKOUT_PO             "Checkout translations files from KDE repositories (default=OFF)"                        OFF)
option(DIGIKAMSC_COMPILE_PO              "Build translations files (default=ON)"                                                  ON)
option(DIGIKAMSC_COMPILE_DOC             "Build handbook files (default=ON)"                                                      ON)
option(DIGIKAMSC_USE_PRIVATE_SHAREDLIBS  "Build local shared libraries instead of using distributed files (default=OFF)"          OFF)

###########################################################################################################################################

MACRO_BOOL_TO_01(DIGIKAMSC_CHECKOUT_PO ENABLE_CHECKOUT_PO)
MACRO_BOOL_TO_01(DIGIKAMSC_COMPILE_PO  ENABLE_COMPILE_PO)
MACRO_BOOL_TO_01(DIGIKAMSC_COMPILE_DOC ENABLE_COMPILE_DOC)

# If building for KDE<4.6.95, we need to build some parts of KDE-graphics
# by ourselves, because we depend on newer versions. If you want
# to force building of these libraries, specify -DDIGIKAMSC_USE_PRIVATE_KDEGRAPHICS:BOOL=1
# as an argument to CMake.
if(NOT DIGIKAMSC_USE_PRIVATE_SHAREDLIBS)

    if(${KDE_VERSION} VERSION_LESS "4.6.95")
        set(ENABLE_PRIVATE_SHAREDLIBS 1)
    else()
        set(ENABLE_PRIVATE_SHAREDLIBS 0)
    endif()

else()

    set(ENABLE_PRIVATE_SHAREDLIBS 1)

endif()

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

message(STATUS "----------------------------------------------------------------------------------")
message(STATUS "Starting CMake configuration for: digiKam Software Collection")

if(ENABLE_PRIVATE_SHAREDLIBS)
    message(STATUS "Local shared libraries will be compiled........ YES")
else()
    message(STATUS "Local shared libraries will be compiled........ NO")
endif()

if(DIGIKAMSC_COMPILE_DOC)
    message(STATUS "Handbooks will be compiled..................... YES")
else()
    message(STATUS "Handbooks will be compiled..................... NO")
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

############################################################################################################################################

if(ENABLE_COMPILE_PO)
    set_property(GLOBAL PROPERTY ALLOW_DUPLICATE_CUSTOM_TARGETS 1)
endif()

if(KDE4_BUILD_TESTS)
    include(CTest)
    ENABLE_TESTING()
endif()

# Make sure that the FindXXX modules of the local libraries are found
if(ENABLE_PRIVATE_SHAREDLIBS)
    # prepend our own FindXXX modules to CMAKE_MODULE_PATH
    set(CMAKE_MODULE_PATH
        ${CMAKE_SOURCE_DIR}/extra/libkdcraw/cmake/modules
        ${CMAKE_MODULE_PATH}
       )
endif()

# prepend our own FindXXX modules to CMAKE_MODULE_PATH
set(CMAKE_MODULE_PATH
    ${CMAKE_SOURCE_DIR}/extra/libkgeomap/cmake/modules
    ${CMAKE_SOURCE_DIR}/extra/libmediawiki/cmake/modules
    ${CMAKE_SOURCE_DIR}/extra/libkvkontakte/cmake/modules
    ${CMAKE_SOURCE_DIR}/cmake/modules
    ${CMAKE_MODULE_PATH}
   )

if(ENABLE_PRIVATE_SHAREDLIBS)
    # from kdegraphics/libs
    set(KIPI_LOCAL_DIR   extra/libkipi)
    set(KEXIV2_LOCAL_DIR extra/libkexiv2)
    set(KDCRAW_LOCAL_DIR extra/libkdcraw)
    set(KFACE_LOCAL_DIR  extra/libkface)
    set(KSANE_LOCAL_DIR  extra/libksane)

    #from extragear/libs
    set(KGEOMAP_LOCAL_DIR       extra/libkgeomap)
    set(MEDIAWIKI_LOCAL_DIR     extra/libmediawiki)
    set(LIBKVKONTAKTE_LOCAL_DIR extra/libkvkontakte)
endif()

add_subdirectory(extra)
add_subdirectory(core)

if(ENABLE_COMPILE_DOC)
    MACRO_OPTIONAL_ADD_SUBDIRECTORY(doc)
endif()

if(ENABLE_COMPILE_PO)
    find_package(Msgfmt  REQUIRED)
    find_package(Gettext REQUIRED)
    add_subdirectory(po)
endif()
