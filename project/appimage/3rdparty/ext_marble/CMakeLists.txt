set(EXTPREFIX_marble "${EXTPREFIX}" )

set(KA_VERSION 16.04.3)

ExternalProject_Add(
    ext_marble
    DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}
    URL http://download.kde.org/stable/applications/${KA_VERSION}/src/marble-${KA_VERSION}.xz
    INSTALL_DIR ${EXTPREFIX_marble}
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${EXTPREFIX_marble}
               -DCMAKE_BUILD_TYPE=${GLOBAL_BUILD_TYPE}
               ${GLOBAL_PROFILE}
               -DCMAKE_SYSTEM_PREFIX_PATH=${EXTPREFIX}
               -DWITH_DESIGNER_PLUGIN=OFF
               -DBUILD_MARBLE_TESTS=OFF
               -DBUILD_MARBLE_TOOLS=OFF
               -DBUILD_MARBLE_EXAMPLES=OFF
               -DBUILD_MARBLE_APPS=OFF
               -DBUILD_WITH_DBUS=OFF
               -DQTONLY=ON
               -DBUILD_TESTING=OFF
               -Wno-dev
    UPDATE_COMMAND ""
    ALWAYS 0
)
