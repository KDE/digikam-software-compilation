# - Try to find the VKONTAKTE library
#
# If you have put a local version of libkvkontakte into your source tree,
# set LIBKVKONTAKTE_LOCAL_DIR to the relative path to the local directory.
#
# Once done this will define
#
#  LIBKVKONTAKTE_FOUND - system has libkvkontakte
#  LIBKVKONTAKTE_INCLUDES - the libkvkontakte include directory
#  LIBKVKONTAKTE_LIBRARIES - Link these to use libkvkontakte
#  LIBKVKONTAKTE_DEFINITIONS - Compiler switches required for using libkvkontakte
#

# Copyright (c) 2010, Gilles Caulier, <caulier.gilles@gmail.com>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.

IF (LIBKVKONTAKTE_INCLUDES AND LIBKVKONTAKTE_LIBRARIES AND LIBKVKONTAKTE_DEFINITIONS)

  MESSAGE(STATUS "Found Vkontakte library in cache: ${LIBKVKONTAKTE_LIBRARIES}")

  # in cache already
  SET(LIBKVKONTAKTE_FOUND TRUE)

ELSE (LIBKVKONTAKTE_INCLUDES AND LIBKVKONTAKTE_LIBRARIES AND LIBKVKONTAKTE_DEFINITIONS)

  MESSAGE(STATUS "Check Vkontakte library in local sub-folder...")

  # Check if library is not in local sub-folder

  IF (LIBKVKONTAKTE_LOCAL_DIR)
    SET(VKONTAKTE_LOCAL_FOUND TRUE)
  ELSE (LIBKVKONTAKTE_LOCAL_DIR)
    FIND_FILE(VKONTAKTE_LOCAL_FOUND libkvkontakte/version.h.cmake ${CMAKE_SOURCE_DIR}/libkvkontakte ${CMAKE_SOURCE_DIR}/libs/libkvkontakte NO_DEFAULT_PATH)

    IF (VKONTAKTE_LOCAL_FOUND)
      FIND_FILE(VKONTAKTE_LOCAL_FOUND_IN_LIBS libkvkontakte/version.h.cmake ${CMAKE_SOURCE_DIR}/libs/libkvkontakte NO_DEFAULT_PATH)
      IF (VKONTAKTE_LOCAL_FOUND_IN_LIBS)
        SET(LIBKVKONTAKTE_LOCAL_DIR libs/libkvkontakte)
      ELSE (VKONTAKTE_LOCAL_FOUND_IN_LIBS)
        SET(LIBKVKONTAKTE_LOCAL_DIR libkvkontakte)
      ENDIF (VKONTAKTE_LOCAL_FOUND_IN_LIBS)
    ENDIF (VKONTAKTE_LOCAL_FOUND)
  ENDIF (LIBKVKONTAKTE_LOCAL_DIR)

  IF (VKONTAKTE_LOCAL_FOUND)

    # we need two include directories: because the version.h file is put into the build directory
    # TODO LIBKVKONTAKTE_INCLUDES sounds like it should contain only one directory...
    SET(LIBKVKONTAKTE_INCLUDES ${CMAKE_SOURCE_DIR}/${LIBKVKONTAKTE_LOCAL_DIR} ${CMAKE_BINARY_DIR}/${LIBKVKONTAKTE_LOCAL_DIR})
    SET(LIBKVKONTAKTE_DEFINITIONS "-I${CMAKE_SOURCE_DIR}/${LIBKVKONTAKTE_LOCAL_DIR}" "-I${CMAKE_BINARY_DIR}/${LIBKVKONTAKTE_LOCAL_DIR}")
    SET(LIBKVKONTAKTE_LIBRARIES kvkontakte)
    MESSAGE(STATUS "Found Vkontakte library in local sub-folder: ${CMAKE_SOURCE_DIR}/${LIBKVKONTAKTE_LOCAL_DIR}")
    SET(LIBKVKONTAKTE_FOUND TRUE)
    MARK_AS_ADVANCED(LIBKVKONTAKTE_INCLUDES LIBKVKONTAKTE_LIBRARIES LIBKVKONTAKTE_DEFINITIONS)

  ELSE(VKONTAKTE_LOCAL_FOUND)
    IF(NOT WIN32) 
      MESSAGE(STATUS "Check Vkontakte library using pkg-config...")

      # use pkg-config to get the directories and then use these values
      # in the FIND_PATH() and FIND_LIBRARY() calls
      INCLUDE(UsePkgConfig)

      PKGCONFIG(libkvkontakte _VKONTAKTEIncDir _VKONTAKTELinkDir _VKONTAKTELinkFlags _VKONTAKTECflags)

      IF(_VKONTAKTELinkFlags)
        # query pkg-config asking for a libkvkontakte >= 1.0.0
        EXEC_PROGRAM(${PKGCONFIG_EXECUTABLE} ARGS --atleast-version=1.0.0 libkvkontakte RETURN_VALUE _return_VALUE OUTPUT_VARIABLE _pkgconfigDevNull )
        IF(_return_VALUE STREQUAL "0")
            MESSAGE(STATUS "Found libkvkontakte release >= 1.0.0")
            SET(VKONTAKTE_VERSION_GOOD_FOUND TRUE)
        ELSE(_return_VALUE STREQUAL "0")
            MESSAGE(STATUS "Found libkvkontakte release < 1.0.0, too old")
            SET(VKONTAKTE_VERSION_GOOD_FOUND FALSE)
            SET(LIBKVKONTAKTE_FOUND FALSE)
        ENDIF(_return_VALUE STREQUAL "0")
      ELSE(_VKONTAKTELinkFlags)
        SET(VKONTAKTE_VERSION_GOOD_FOUND FALSE)
        SET(LIBKVKONTAKTE_FOUND FALSE)
      ENDIF(_VKONTAKTELinkFlags)
    ELSE(NOT WIN32)
      SET(VKONTAKTE_VERSION_GOOD_FOUND TRUE)
    ENDIF(NOT WIN32)

    IF(VKONTAKTE_VERSION_GOOD_FOUND)
        SET(LIBKVKONTAKTE_DEFINITIONS "${_VKONTAKTECflags}")

        FIND_PATH(LIBKVKONTAKTE_INCLUDES libkvkontakte/version.h
        ${_VKONTAKTEIncDir}
        )

        FIND_LIBRARY(LIBKVKONTAKTE_LIBRARIES NAMES kvkontakte
        PATHS
        ${_VKONTAKTELinkDir}
        )

        IF (LIBKVKONTAKTE_INCLUDES AND LIBKVKONTAKTE_LIBRARIES)
            SET(LIBKVKONTAKTE_FOUND TRUE)
        ENDIF (LIBKVKONTAKTE_INCLUDES AND LIBKVKONTAKTE_LIBRARIES)
      ENDIF(VKONTAKTE_VERSION_GOOD_FOUND) 
      IF (LIBKVKONTAKTE_FOUND)
          IF (NOT Vkontakte_FIND_QUIETLY)
              MESSAGE(STATUS "Found libkvkontakte: ${LIBKVKONTAKTE_LIBRARIES}")
          ENDIF (NOT Vkontakte_FIND_QUIETLY)
      ELSE (LIBKVKONTAKTE_FOUND)
          IF (Vkontakte_FIND_REQUIRED)
              IF (NOT LIBKVKONTAKTE_INCLUDES)
                  MESSAGE(FATAL_ERROR "Could NOT find libkvkontakte header files")
              ENDIF (NOT LIBKVKONTAKTE_INCLUDES)
              IF (NOT LIBKVKONTAKTE_LIBRARIES)
                  MESSAGE(FATAL_ERROR "Could NOT find libkvkontakte library")
              ENDIF (NOT LIBKVKONTAKTE_LIBRARIES)
          ENDIF (Vkontakte_FIND_REQUIRED)
      ENDIF (LIBKVKONTAKTE_FOUND)

    MARK_AS_ADVANCED(LIBKVKONTAKTE_INCLUDES LIBKVKONTAKTE_LIBRARIES LIBKVKONTAKTE_DEFINITIONS)

  ENDIF(VKONTAKTE_LOCAL_FOUND)

ENDIF (LIBKVKONTAKTE_INCLUDES AND LIBKVKONTAKTE_LIBRARIES AND LIBKVKONTAKTE_DEFINITIONS)
