# Try to find the Ksane library
#
# Parameters:
#  KSANE_LOCAL_DIR - If you have put a local version of libksane into
#                     your source tree, set KSANE_LOCAL_DIR to the
#                     relative path from the root of your source tree
#                     to the libksane local directory.
#
# Once done this will define
#
#  KSANE_FOUND - System has libksane
#  KSANE_INCLUDE_DIR - The libksane include directory/directories (for #include <libksane/...> style)
#  KSANE_LIBRARY - Link these to use libksane
#  KSANE_DEFINITIONS - Compiler switches required for using libksane
#  KSANE_VERSION - Version of libksane which was found
#
# Copyright (c) 2008-2014, Gilles Caulier, <caulier.gilles@gmail.com>
# Copyright (c) 2011, Michael G. Hansen, <mike@mghansen.de>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.

# Ksane_FIND_QUIETLY and Ksane_FIND_REQUIRED may be defined by CMake.

if (KSANE_INCLUDE_DIR AND KSANE_LIBRARY AND KSANE_DEFINITIONS AND KSANE_VERSION)

  if (NOT Ksane_FIND_QUIETLY)
    message(STATUS "Found Ksane library in cache: ${KSANE_LIBRARY}")
  endif (NOT Ksane_FIND_QUIETLY)

  # in cache already
  set(KSANE_FOUND TRUE)

else (KSANE_INCLUDE_DIR AND KSANE_LIBRARY AND KSANE_DEFINITIONS AND KSANE_VERSION)

  if (NOT Ksane_FIND_QUIETLY)
    message(STATUS "Check for Ksane library in local sub-folder...")
  endif (NOT Ksane_FIND_QUIETLY)

  # Check for a local version of the library.
  if (KSANE_LOCAL_DIR)
    find_file(KSANE_LOCAL_FOUND libksane/libksane_export.h ${CMAKE_SOURCE_DIR}/${KSANE_LOCAL_DIR} NO_DEFAULT_PATH)
    if (NOT KSANE_LOCAL_FOUND)
      message(WARNING "KSANE_LOCAL_DIR specified as \"${KSANE_LOCAL_DIR}\" but libksane could not be found there.")
    endif (NOT KSANE_LOCAL_FOUND)
  else (KSANE_LOCAL_DIR)
    find_file(KSANE_LOCAL_FOUND libksane/libksane_export.h ${CMAKE_SOURCE_DIR}/libksane NO_DEFAULT_PATH)
    if (KSANE_LOCAL_FOUND)
      set(KSANE_LOCAL_DIR libksane)
    endif (KSANE_LOCAL_FOUND)
    find_file(KSANE_LOCAL_FOUND libksane/libksane_export.h ${CMAKE_SOURCE_DIR}/libs/libksane NO_DEFAULT_PATH)
    if (KSANE_LOCAL_FOUND)
      set(KSANE_LOCAL_DIR libs/libksane)
    endif (KSANE_LOCAL_FOUND)
  endif (KSANE_LOCAL_DIR)

  if (KSANE_LOCAL_FOUND)
    # We need two include directories: because the version.h file is put into the build directory
    # TODO KSANE_INCLUDE_DIR sounds like it should contain only one directory...
    set(KSANE_INCLUDE_DIR ${CMAKE_SOURCE_DIR}/${KSANE_LOCAL_DIR} ${CMAKE_BINARY_DIR}/${KSANE_LOCAL_DIR})
    set(KSANE_DEFINITIONS "-I${CMAKE_SOURCE_DIR}/${KSANE_LOCAL_DIR}" "-I${CMAKE_BINARY_DIR}/${KSANE_LOCAL_DIR}")
    set(KSANE_LIBRARY ksane)
    if (NOT Ksane_FIND_QUIETLY)
      message(STATUS "Found Ksane library in local sub-folder: ${CMAKE_SOURCE_DIR}/${KSANE_LOCAL_DIR}")
    endif (NOT Ksane_FIND_QUIETLY)
    set(KSANE_FOUND TRUE)

    set(ksane_version_h_filename "${CMAKE_BINARY_DIR}/${KSANE_LOCAL_DIR}/libksane/version.h")

  else (KSANE_LOCAL_FOUND)
    if (NOT WIN32)
      if (NOT Ksane_FIND_QUIETLY)
        message(STATUS "Check Ksane library using pkg-config...")
      endif (NOT Ksane_FIND_QUIETLY)

      # use FindPkgConfig to get the directories and then use these values
      # in the find_path() and find_library() calls
      include(FindPkgConfig)

      pkg_search_module(KSANE libksane)

      if (KSANE_FOUND)
        # make sure the version is >= 0.2.0
        # TODO: WHY?
        if (KSANE_VERSION VERSION_LESS 0.2.0)
          message(STATUS "Found libksane release < 0.2.0, too old")
          set(KSANE_VERSION_GOOD_FOUND FALSE)
          set(KSANE_FOUND FALSE)
        else (KSANE_VERSION VERSION_LESS 0.2.0)
          if (NOT Ksane_FIND_QUIETLY)
            message(STATUS "Found libksane release ${KSANE_VERSION}")
          endif (NOT Ksane_FIND_QUIETLY)
          set(KSANE_VERSION_GOOD_FOUND TRUE)
        endif (KSANE_VERSION VERSION_LESS 0.2.0)
      else (KSANE_FOUND)
        set(KSANE_VERSION_GOOD_FOUND FALSE)
      endif (KSANE_FOUND)
    else (NOT WIN32)
      # TODO: Why do we just assume the version is good?
      set(KSANE_VERSION_GOOD_FOUND TRUE)
    endif (NOT WIN32)

    if (KSANE_VERSION_GOOD_FOUND)
      set(KSANE_DEFINITIONS "${KSANE_CFLAGS}")

      find_path(KSANE_INCLUDE_DIR libksane/version.h ${KSANE_INCLUDEDIR})
      set(ksane_version_h_filename "${KSANE_INCLUDE_DIR}/libksane/version.h")

      find_library(KSANE_LIBRARY NAMES ksane PATHS ${KSANE_LIBDIR})

      if (KSANE_INCLUDE_DIR AND KSANE_LIBRARY)
        set(KSANE_FOUND TRUE)
      else (KSANE_INCLUDE_DIR AND KSANE_LIBRARY)
        set(KSANE_FOUND FALSE)
      endif (KSANE_INCLUDE_DIR AND KSANE_LIBRARY)
    endif (KSANE_VERSION_GOOD_FOUND)

    if (KSANE_FOUND)
      if (NOT Ksane_FIND_QUIETLY)
        message(STATUS "Found libksane: ${KSANE_LIBRARY}")
      endif (NOT Ksane_FIND_QUIETLY)
    else (KSANE_FOUND)
      if (Ksane_FIND_REQUIRED)
        if (NOT KSANE_INCLUDE_DIR)
          message(FATAL_ERROR "Could NOT find libksane header files.")
        else(NOT KSANE_INCLUDE_DIR)
          message(FATAL_ERROR "Could NOT find libksane library.")
        endif (NOT KSANE_INCLUDE_DIR)
      endif (Ksane_FIND_REQUIRED)
    endif (KSANE_FOUND)

  endif (KSANE_LOCAL_FOUND)

  if (KSANE_FOUND)
    # Find the version information, unless that was reported by pkg_search_module.
    if (NOT KSANE_VERSION)
      file(READ "${ksane_version_h_filename}" ksane_version_h_content)
      # This is the line we are trying to find: static const char ksane_version[] = "1.22.4-beta_5+dfsg";
      string(REGEX REPLACE ".*char +ksane_version\\[\\] += +\"([^\"]+)\".*" "\\1" KSANE_VERSION "${ksane_version_h_content}")
      unset(ksane_version_h_content)

    endif (NOT KSANE_VERSION)
    unset(ksane_version_h_filename)
  endif (KSANE_FOUND)

  if (KSANE_FOUND)
    mark_as_advanced(KSANE_INCLUDE_DIR KSANE_LIBRARY KSANE_DEFINITIONS KSANE_VERSION KSANE_FOUND)
  else (KSANE_FOUND)
    # The library was not found, reset all related variables.
    unset(KSANE_INCLUDE_DIR)
    unset(KSANE_LIBRARY)
    unset(KSANE_DEFINITIONS)
    unset(KSANE_VERSION)
  endif (KSANE_FOUND)

endif (KSANE_INCLUDE_DIR AND KSANE_LIBRARY AND KSANE_DEFINITIONS AND KSANE_VERSION)
