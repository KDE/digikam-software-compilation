cmake_minimum_required(VERSION 2.8.9)

FIND_PACKAGE(Qt5Core         REQUIRED)
FIND_PACKAGE(Qt5Gui          REQUIRED)

include_directories(${Qt5Core_INCLUDE_DIRS}
                    ${Qt5Gui_INCLUDE_DIRS}
                    ${CMAKE_CURRENT_BINARY_DIR}
)

add_executable(png2ico png2ico.cpp qicohandler.cpp qicohandler.h qcurhandler.cpp qcurhandler.h qanihandler.cpp qanihandler.h)

target_link_libraries(png2ico Qt5::Core Qt5::Gui)

install(TARGETS png2ico DESTINATION bin)
