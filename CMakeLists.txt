#
# Copyright (c) 2010-2015, Gilles Caulier, <caulier dot gilles at gmail dot com>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.

project(digikam-software-collection)

message(STATUS "----------------------------------------------------------------------------------")
message(STATUS "Starting CMake configuration for: ${PROJECT_NAME}")

set(CMAKE_MIN_VERSION   "3.0.0")
set(ECM_MIN_VERSION     "1.7.0")

cmake_minimum_required(VERSION ${CMAKE_MIN_VERSION})

############## ECM setup #################################################################################################################

find_package(ECM ${ECM_MIN_VERSION} CONFIG REQUIRED)
set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH})

include(ECMGenerateHeaders)
include(ECMGeneratePriFile)
include(ECMPackageConfigHelpers)
include(ECMSetupVersion)
include(ECMMarkNonGuiExecutable)
include(ECMOptionalAddSubdirectory)
include(KDEInstallDirs)
include(KDECMakeSettings)
include(KDEFrameworkCompilerSettings)
include(GenerateExportHeader)
include(FeatureSummary)

# COMPILATION OPTIONS MANAGEMENT ###########################################################################################################

# doc and translations options

option(DIGIKAMSC_CHECKOUT_PO             "Checkout translations files from KDE repositories (default=OFF)"                        OFF)
option(DIGIKAMSC_COMPILE_PO              "Build translations files (default=ON)"                                                  ON)
option(DIGIKAMSC_COMPILE_DOC             "Build handbook files (default=ON)"                                                      ON)

# shared libs options

option(DIGIKAMSC_COMPILE_LIBKIPI         "Build local libkipi library instead of using distributed files (default=ON)"            ON)
option(DIGIKAMSC_COMPILE_LIBKEXIV2       "Build local libkexiv2 library instead of using distributed files (default=ON)"          ON)
option(DIGIKAMSC_COMPILE_LIBKDCRAW       "Build local libkdcraw library instead of using distributed files (default=ON)"          ON)
option(DIGIKAMSC_COMPILE_LIBKFACE        "Build local libkface library instead of using distributed files (default=ON)"           ON)
option(DIGIKAMSC_COMPILE_LIBKGEOMAP      "Build local libkgeomap library instead of using distributed files (default=OFF)"        OFF)
option(DIGIKAMSC_COMPILE_LIBKSANE        "Build local libksane library instead of using distributed files (default=OFF)"          OFF)
option(DIGIKAMSC_COMPILE_LIBMEDIAWIKI    "Build local libmediawiki library instead of using distributed files (default=OFF)"      OFF)
option(DIGIKAMSC_COMPILE_LIBKVKONTAKTE   "Build local libkvkontakte library instead of using distributed files (default=OFF)"     OFF)

option(DIGIKAMSC_COMPILE_PLUGINS         "Build Kipi-plugins (default=ON)"                                                        ON)
option(DIGIKAMSC_COMPILE_CORE            "Build digiKam core (default=ON)"                                                        ON)

###########################################################################################################################################

if(DIGIKAMSC_CHECKOUT_PO)

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

if(DIGIKAMSC_COMPILE_PO AND NOT EXISTS ${CMAKE_SOURCE_DIR}/po/)

    message(STATUS "${CMAKE_SOURCE_DIR}/po/ dir do not exists. Translations compilation disabled...")

    if(NOT DIGIKAMSC_CHECKOUT_PO)
        message(STATUS "You can use DIGIKAMSC_CHECKOUT_PO option to extract po files from KDE repositories.")
    endif()

    set(DIGIKAMSC_COMPILE_PO OFF)

endif()

if(DIGIKAMSC_COMPILE_PO)
    set_property(GLOBAL PROPERTY ALLOW_DUPLICATE_CUSTOM_TARGETS 1)
endif()

if(BUILD_TESTING)
    include(CTest)
endif()

############################################################################################################################################

if(DIGIKAMSC_COMPILE_LIBKIPI)
    message(STATUS "Local shared libkipi will be compiled.......... YES")
else()
    message(STATUS "Local shared libkipi will be compiled.......... NO")
endif()

if(DIGIKAMSC_COMPILE_LIBKEXIV2)
    message(STATUS "Local shared libkexiv2 will be compiled........ YES")
else()
    message(STATUS "Local shared libkexiv2 will be compiled........ NO")
endif()

if(DIGIKAMSC_COMPILE_LIBKDCRAW)
    message(STATUS "Local shared libkdcraw will be compiled........ YES")
else()
    message(STATUS "Local shared libkdcraw will be compiled........ NO")
endif()

if(DIGIKAMSC_COMPILE_LIBKSANE)
    message(STATUS "Local shared libksane will be compiled......... YES")
else()
    message(STATUS "Local shared libksane will be compiled......... NO")
endif()

if(DIGIKAMSC_COMPILE_LIBKFACE)
    message(STATUS "Local shared libkface will be compiled......... YES")
else()
    message(STATUS "Local shared libkface will be compiled......... NO")
endif()

if(DIGIKAMSC_COMPILE_LIBKGEOMAP)
    message(STATUS "Local shared libkgeomap will be compiled....... YES")
else()
    message(STATUS "Local shared libkgeomap will be compiled....... NO")
endif()

if(DIGIKAMSC_COMPILE_LIBMEDIAWIKI)
    message(STATUS "Local shared libmediawiki will be compiled..... YES")
else()
    message(STATUS "Local shared libmediawiki will be compiled..... NO")
endif()

if(DIGIKAMSC_COMPILE_LIBKVKONTAKTE)
    message(STATUS "Local shared libkvkontakte will be compiled.... YES")
else()
    message(STATUS "Local shared libkvkontakte will be compiled.... NO")
endif()

if(DIGIKAMSC_CHECKOUT_PO)
    message(STATUS "Extract translations files..................... YES")
else()
    message(STATUS "Extract translations files..................... NO")
endif()

if(DIGIKAMSC_COMPILE_PO)
    message(STATUS "Translations will be compiled.................. YES")
else()
    message(STATUS "Translations will be compiled.................. NO")
endif()

if(DIGIKAMSC_COMPILE_DOC)
    message(STATUS "Handbooks will be compiled..................... YES")
else()
    message(STATUS "Handbooks will be compiled..................... NO")
endif()

if(DIGIKAMSC_COMPILE_PLUGINS)
    message(STATUS "Kipi-plugins will be compiled.................. YES")
else()
    message(STATUS "Kipi-plugins will be compiled.................. NO")
endif()

if(DIGIKAMSC_COMPILE_CORE)
    message(STATUS "digiKam core will be compiled.................. YES")
else()
    message(STATUS "digiKam core will be compiled.................. NO")
endif()

if(BUILD_TESTING)
    message(STATUS "Tests code will be compiled.................... YES")
else()
    message(STATUS "Tests code will be compiled.................... NO")
endif()

#############################################################################################

add_subdirectory(extra)

if(DIGIKAMSC_COMPILE_CORE)
    add_subdirectory(core)
endif()

if(DIGIKAMSC_COMPILE_DOC)
    ECM_OPTIONAL_ADD_SUBDIRECTORY(doc)
    ECM_OPTIONAL_ADD_SUBDIRECTORY(doc-translated)
endif()

if(DIGIKAMSC_COMPILE_PO)
    find_package(Msgfmt  REQUIRED)
    find_package(Gettext REQUIRED)
    add_subdirectory(po)
endif()
