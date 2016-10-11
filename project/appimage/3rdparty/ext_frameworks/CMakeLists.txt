set(EXTPREFIX_frameworks "${EXTPREFIX}")

set(KD_VERSION 5.26)

ExternalProject_Add(
    ext_extra_cmake_modules
    DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}
    URL http://download.kde.org/stable/frameworks/${KD_VERSION}/extra-cmake-modules-${KD_VERSION}.0.tar.xz
    INSTALL_DIR ${EXTPREFIX_frameworks}
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${EXTPREFIX_frameworks}
               -DCMAKE_BUILD_TYPE=${GLOBAL_BUILD_TYPE}
               ${GLOBAL_PROFILE}
               -DCMAKE_SYSTEM_PREFIX_PATH=${EXTPREFIX}
               -DBUILD_TESTING=OFF
               -Wno-dev
    UPDATE_COMMAND ""
    ALWAYS 0
)

ExternalProject_Add(
    ext_kconfig
    DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}
    URL http://download.kde.org/stable/frameworks/${KD_VERSION}/kconfig-${KD_VERSION}.0.tar.xz
    INSTALL_DIR ${EXTPREFIX_frameworks}
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${EXTPREFIX_frameworks}
               -DCMAKE_BUILD_TYPE=${GLOBAL_BUILD_TYPE}
               ${GLOBAL_PROFILE}
               -DCMAKE_SYSTEM_PREFIX_PATH=${EXTPREFIX}
               -DBUILD_TESTING=OFF
               -Wno-dev
    UPDATE_COMMAND ""
    ALWAYS 0
)

ExternalProject_Add(
    ext_breeze_icons
    DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}
    URL http://download.kde.org/stable/frameworks/${KD_VERSION}/breeze-icons-${KD_VERSION}.0.tar.xz
    INSTALL_DIR ${EXTPREFIX_frameworks}
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${EXTPREFIX_frameworks}
               -DCMAKE_BUILD_TYPE=${GLOBAL_BUILD_TYPE}
               ${GLOBAL_PROFILE}
               -DCMAKE_SYSTEM_PREFIX_PATH=${EXTPREFIX}
               -DBUILD_TESTING=OFF
               -Wno-dev
    UPDATE_COMMAND ""
    ALWAYS 0
)

ExternalProject_Add(
    ext_solid
    DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}
    URL http://download.kde.org/stable/frameworks/${KD_VERSION}/solid-${KD_VERSION}.0.tar.xz
    INSTALL_DIR ${EXTPREFIX_frameworks}
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${EXTPREFIX_frameworks}
               -DCMAKE_BUILD_TYPE=${GLOBAL_BUILD_TYPE}
               ${GLOBAL_PROFILE}
               -DCMAKE_SYSTEM_PREFIX_PATH=${EXTPREFIX}
               -DBUILD_TESTING=OFF
               -Wno-dev
    UPDATE_COMMAND ""
    ALWAYS 0
)

ExternalProject_Add(
    ext_kcoreaddons
    DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}
    URL http://download.kde.org/stable/frameworks/${KD_VERSION}/kcoreaddons-${KD_VERSION}.0.tar.xz
    INSTALL_DIR ${EXTPREFIX_frameworks}
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${EXTPREFIX_frameworks}
               -DCMAKE_BUILD_TYPE=${GLOBAL_BUILD_TYPE}
               ${GLOBAL_PROFILE}
               -DCMAKE_SYSTEM_PREFIX_PATH=${EXTPREFIX}
               -DBUILD_TESTING=OFF
               -Wno-dev
    UPDATE_COMMAND ""
    ALWAYS 0
)

ExternalProject_Add(
    ext_threadweaver
    DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}
    URL http://download.kde.org/stable/frameworks/${KD_VERSION}/threadweaver-${KD_VERSION}.0.tar.xz
    INSTALL_DIR ${EXTPREFIX_frameworks}
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${EXTPREFIX_frameworks}
               -DCMAKE_BUILD_TYPE=${GLOBAL_BUILD_TYPE}
               ${GLOBAL_PROFILE}
               -DCMAKE_SYSTEM_PREFIX_PATH=${EXTPREFIX}
               -DBUILD_TESTING=OFF
               -Wno-dev
    UPDATE_COMMAND ""
    ALWAYS 0
)

ExternalProject_Add(
    ext_kwindowsystem
    DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}
    URL http://download.kde.org/stable/frameworks/${KD_VERSION}/kwindowsystem-${KD_VERSION}.0.tar.xz
    INSTALL_DIR ${EXTPREFIX_frameworks}
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${EXTPREFIX_frameworks}
               -DCMAKE_BUILD_TYPE=${GLOBAL_BUILD_TYPE}
               ${GLOBAL_PROFILE}
               -DCMAKE_SYSTEM_PREFIX_PATH=${EXTPREFIX}
               -DBUILD_TESTING=OFF
               -Wno-dev
    UPDATE_COMMAND ""
    ALWAYS 0
)

ExternalProject_Add(
    ext_karchive
    DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}
    URL http://download.kde.org/stable/frameworks/${KD_VERSION}/karchive-${KD_VERSION}.0.tar.xz
    INSTALL_DIR ${EXTPREFIX_frameworks}
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${EXTPREFIX_frameworks}
               -DCMAKE_BUILD_TYPE=${GLOBAL_BUILD_TYPE}
               ${GLOBAL_PROFILE}
               -DCMAKE_SYSTEM_PREFIX_PATH=${EXTPREFIX}
               -DBUILD_TESTING=OFF
               -Wno-dev
    UPDATE_COMMAND ""
    ALWAYS 0
)

ExternalProject_Add(
    ext_kdbusaddons
    DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}
    URL http://download.kde.org/stable/frameworks/${KD_VERSION}/kdbusaddons-${KD_VERSION}.0.tar.xz
    INSTALL_DIR ${EXTPREFIX_frameworks}
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${EXTPREFIX_frameworks}
               -DCMAKE_BUILD_TYPE=${GLOBAL_BUILD_TYPE}
               ${GLOBAL_PROFILE}
               -DCMAKE_SYSTEM_PREFIX_PATH=${EXTPREFIX}
               -DBUILD_TESTING=OFF
               -Wno-dev
    UPDATE_COMMAND ""
    ALWAYS 0
)

ExternalProject_Add(
    ext_ki18n
    DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}
    URL http://download.kde.org/stable/frameworks/${KD_VERSION}/ki18n-${KD_VERSION}.0.tar.xz
    INSTALL_DIR ${EXTPREFIX_frameworks}
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${EXTPREFIX_frameworks}
               -DCMAKE_BUILD_TYPE=${GLOBAL_BUILD_TYPE}
               ${GLOBAL_PROFILE}
               -DCMAKE_SYSTEM_PREFIX_PATH=${EXTPREFIX}
               -DBUILD_TESTING=OFF
               -Wno-dev
    UPDATE_COMMAND ""
    ALWAYS 0
)

ExternalProject_Add(
    ext_kcrash
    DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}
    URL http://download.kde.org/stable/frameworks/${KD_VERSION}/kcrash-${KD_VERSION}.0.tar.xz
    INSTALL_DIR ${EXTPREFIX_frameworks}
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${EXTPREFIX_frameworks}
               -DCMAKE_BUILD_TYPE=${GLOBAL_BUILD_TYPE}
               ${GLOBAL_PROFILE}
               -DCMAKE_SYSTEM_PREFIX_PATH=${EXTPREFIX}
               -DBUILD_TESTING=OFF
               -Wno-dev
    UPDATE_COMMAND ""
    ALWAYS 0
)

ExternalProject_Add(
    ext_kcodecs
    DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}
    URL http://download.kde.org/stable/frameworks/${KD_VERSION}/kcodecs-${KD_VERSION}.0.tar.xz
    INSTALL_DIR ${EXTPREFIX_frameworks}
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${EXTPREFIX_frameworks}
               -DCMAKE_BUILD_TYPE=${GLOBAL_BUILD_TYPE}
               ${GLOBAL_PROFILE}
               -DCMAKE_SYSTEM_PREFIX_PATH=${EXTPREFIX}
               -DBUILD_TESTING=OFF
               -Wno-dev
    UPDATE_COMMAND ""
    ALWAYS 0
)

ExternalProject_Add(
    ext_kauth
    DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}
    URL http://download.kde.org/stable/frameworks/${KD_VERSION}/kauth-${KD_VERSION}.0.tar.xz
    INSTALL_DIR ${EXTPREFIX_frameworks}
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${EXTPREFIX_frameworks}
               -DCMAKE_BUILD_TYPE=${GLOBAL_BUILD_TYPE}
               ${GLOBAL_PROFILE}
               -DCMAKE_SYSTEM_PREFIX_PATH=${EXTPREFIX}
               -DBUILD_TESTING=OFF
               -Wno-dev
    UPDATE_COMMAND ""
    ALWAYS 0
)

ExternalProject_Add(
    ext_kguiaddons
    DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}
    URL http://download.kde.org/stable/frameworks/${KD_VERSION}/kguiaddons-${KD_VERSION}.0.tar.xz
    INSTALL_DIR ${EXTPREFIX_frameworks}
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${EXTPREFIX_frameworks}
               -DCMAKE_BUILD_TYPE=${GLOBAL_BUILD_TYPE}
               ${GLOBAL_PROFILE}
               -DCMAKE_SYSTEM_PREFIX_PATH=${EXTPREFIX}
               -DBUILD_TESTING=OFF
               -Wno-dev
    UPDATE_COMMAND ""
    ALWAYS 0
)

ExternalProject_Add(
    ext_kwidgetsaddons
    DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}
    URL http://download.kde.org/stable/frameworks/${KD_VERSION}/kwidgetsaddons-${KD_VERSION}.0.tar.xz
    INSTALL_DIR ${EXTPREFIX_frameworks}
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${EXTPREFIX_frameworks}
               -DCMAKE_BUILD_TYPE=${GLOBAL_BUILD_TYPE}
               ${GLOBAL_PROFILE}
               -DCMAKE_SYSTEM_PREFIX_PATH=${EXTPREFIX}
               -DBUILD_TESTING=OFF
               -Wno-dev
    UPDATE_COMMAND ""
    ALWAYS 0
)

ExternalProject_Add(
    ext_kitemviews
    DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}
    URL http://download.kde.org/stable/frameworks/${KD_VERSION}/kitemviews-${KD_VERSION}.0.tar.xz
    INSTALL_DIR ${EXTPREFIX_frameworks}
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${EXTPREFIX_frameworks}
               -DCMAKE_BUILD_TYPE=${GLOBAL_BUILD_TYPE}
               ${GLOBAL_PROFILE}
               -DCMAKE_SYSTEM_PREFIX_PATH=${EXTPREFIX}
               -DBUILD_TESTING=OFF
               -Wno-dev
    UPDATE_COMMAND ""
    ALWAYS 0
)

ExternalProject_Add(
    ext_kcompletion
    DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}
    URL http://download.kde.org/stable/frameworks/${KD_VERSION}/kcompletion-${KD_VERSION}.0.tar.xz
    INSTALL_DIR ${EXTPREFIX_frameworks}
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${EXTPREFIX_frameworks}
               -DCMAKE_BUILD_TYPE=${GLOBAL_BUILD_TYPE}
               ${GLOBAL_PROFILE}
               -DCMAKE_SYSTEM_PREFIX_PATH=${EXTPREFIX}
               -DBUILD_TESTING=OFF
               -Wno-dev
    UPDATE_COMMAND ""
    ALWAYS 0
)

ExternalProject_Add(
    ext_kconfigwidgets
    DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}
    URL http://download.kde.org/stable/frameworks/${KD_VERSION}/kconfigwidgets-${KD_VERSION}.0.tar.xz
    INSTALL_DIR ${EXTPREFIX_frameworks}
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${EXTPREFIX_frameworks}
               -DCMAKE_BUILD_TYPE=${GLOBAL_BUILD_TYPE}
               ${GLOBAL_PROFILE}
               -DCMAKE_SYSTEM_PREFIX_PATH=${EXTPREFIX}
               -DBUILD_TESTING=OFF
               -Wno-dev
    UPDATE_COMMAND ""
    ALWAYS 0
)

ExternalProject_Add(
    ext_kiconthemes
    DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}
    URL http://download.kde.org/stable/frameworks/${KD_VERSION}/kiconthemes-${KD_VERSION}.0.tar.xz
    INSTALL_DIR ${EXTPREFIX_frameworks}
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${EXTPREFIX_frameworks}
               -DCMAKE_BUILD_TYPE=${GLOBAL_BUILD_TYPE}
               ${GLOBAL_PROFILE}
               -DCMAKE_SYSTEM_PREFIX_PATH=${EXTPREFIX}
               -DBUILD_TESTING=OFF
               -Wno-dev
    UPDATE_COMMAND ""
    ALWAYS 0
)

ExternalProject_Add(
    ext_kservice
    DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}
    URL http://download.kde.org/stable/frameworks/${KD_VERSION}/kservice-${KD_VERSION}.0.tar.xz
    INSTALL_DIR ${EXTPREFIX_frameworks}
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${EXTPREFIX_frameworks}
               -DCMAKE_BUILD_TYPE=${GLOBAL_BUILD_TYPE}
               ${GLOBAL_PROFILE}
               -DCMAKE_SYSTEM_PREFIX_PATH=${EXTPREFIX}
               -DBUILD_TESTING=OFF
               -Wno-dev
    UPDATE_COMMAND ""
    ALWAYS 0
)

ExternalProject_Add(
    ext_kglobalaccel
    DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}
    URL http://download.kde.org/stable/frameworks/${KD_VERSION}/kglobalaccel-${KD_VERSION}.0.tar.xz
    INSTALL_DIR ${EXTPREFIX_frameworks}
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${EXTPREFIX_frameworks}
               -DCMAKE_BUILD_TYPE=${GLOBAL_BUILD_TYPE}
               ${GLOBAL_PROFILE}
               -DCMAKE_SYSTEM_PREFIX_PATH=${EXTPREFIX}
               -DBUILD_TESTING=OFF
               -Wno-dev
    UPDATE_COMMAND ""
    ALWAYS 0
)

ExternalProject_Add(
    ext_kxmlgui
    DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}
    URL http://download.kde.org/stable/frameworks/${KD_VERSION}/kxmlgui-${KD_VERSION}.0.tar.xz
    INSTALL_DIR ${EXTPREFIX_frameworks}
    PATCH_COMMAND ${PATCH_COMMAND} -p1 -i ${CMAKE_CURRENT_SOURCE_DIR}/kxmlgui-drop-ktextwidgets.patch
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${EXTPREFIX_frameworks}
               -DCMAKE_BUILD_TYPE=${GLOBAL_BUILD_TYPE}
               ${GLOBAL_PROFILE}
               -DCMAKE_SYSTEM_PREFIX_PATH=${EXTPREFIX}
               -DBUILD_TESTING=OFF
               -Wno-dev
    UPDATE_COMMAND ""
    ALWAYS 0
)

ExternalProject_Add(
    ext_kbookmarks
    DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}
    URL http://download.kde.org/stable/frameworks/${KD_VERSION}/kbookmarks-${KD_VERSION}.0.tar.xz
    INSTALL_DIR ${EXTPREFIX_frameworks}
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${EXTPREFIX_frameworks}
               -DCMAKE_BUILD_TYPE=${GLOBAL_BUILD_TYPE}
               ${GLOBAL_PROFILE}
               -DCMAKE_SYSTEM_PREFIX_PATH=${EXTPREFIX}
               -DBUILD_TESTING=OFF
               -Wno-dev
    UPDATE_COMMAND ""
    ALWAYS 0
)

ExternalProject_Add(
    ext_kimageformats
    DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}
    URL http://download.kde.org/stable/frameworks/${KD_VERSION}/kimageformats-${KD_VERSION}.0.tar.xz
    INSTALL_DIR ${EXTPREFIX_frameworks}
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${EXTPREFIX_frameworks}
               -DCMAKE_BUILD_TYPE=${GLOBAL_BUILD_TYPE}
               ${GLOBAL_PROFILE}
               -DCMAKE_SYSTEM_PREFIX_PATH=${EXTPREFIX}
               -DBUILD_TESTING=OFF
               -Wno-dev
    UPDATE_COMMAND ""
    ALWAYS 0
)

ExternalProject_Add(
    ext_knotifyconfig
    DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}
    URL http://download.kde.org/stable/frameworks/${KD_VERSION}/knotifyconfig-${KD_VERSION}.0.tar.xz
    INSTALL_DIR ${EXTPREFIX_frameworks}
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${EXTPREFIX_frameworks}
               -DCMAKE_BUILD_TYPE=${GLOBAL_BUILD_TYPE}
               ${GLOBAL_PROFILE}
               -DCMAKE_SYSTEM_PREFIX_PATH=${EXTPREFIX}
               -DBUILD_TESTING=OFF
               -Wno-dev
    UPDATE_COMMAND ""
    ALWAYS 0
)

ExternalProject_Add(
    ext_knotifications
    DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}
    URL http://download.kde.org/stable/frameworks/${KD_VERSION}/knotifications-${KD_VERSION}.0.tar.xz
    INSTALL_DIR ${EXTPREFIX_frameworks}
    PATCH_COMMAND ${PATCH_COMMAND} -p1 -i ${CMAKE_CURRENT_SOURCE_DIR}/knotifications-drop-phonon.patch
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${EXTPREFIX_frameworks}
               -DCMAKE_BUILD_TYPE=${GLOBAL_BUILD_TYPE}
               ${GLOBAL_PROFILE}
               -DCMAKE_SYSTEM_PREFIX_PATH=${EXTPREFIX}
               -DBUILD_TESTING=OFF
               -Wno-dev
    UPDATE_COMMAND ""
    ALWAYS 0
)

ExternalProject_Add(
    ext_kjobwidgets
    DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}
    URL http://download.kde.org/stable/frameworks/${KD_VERSION}/kjobwidgets-${KD_VERSION}.0.tar.xz
    INSTALL_DIR ${EXTPREFIX_frameworks}
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${EXTPREFIX_frameworks}
               -DCMAKE_BUILD_TYPE=${GLOBAL_BUILD_TYPE}
               ${GLOBAL_PROFILE}
               -DCMAKE_SYSTEM_PREFIX_PATH=${EXTPREFIX}
               -DBUILD_TESTING=OFF
               -Wno-dev
    UPDATE_COMMAND ""
    ALWAYS 0
)

ExternalProject_Add(
    ext_sonnet
    DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}
    URL http://download.kde.org/stable/frameworks/${KD_VERSION}/sonnet-${KD_VERSION}.0.tar.xz
    INSTALL_DIR ${EXTPREFIX_frameworks}
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${EXTPREFIX_frameworks}
               -DCMAKE_BUILD_TYPE=${GLOBAL_BUILD_TYPE}
               ${GLOBAL_PROFILE}
               -DCMAKE_SYSTEM_PREFIX_PATH=${EXTPREFIX}
               -DBUILD_TESTING=OFF
               -Wno-dev
    UPDATE_COMMAND ""
    ALWAYS 0
)

ExternalProject_Add(
    ext_ktextwidgets
    DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}
    URL http://download.kde.org/stable/frameworks/${KD_VERSION}/ktextwidgets-${KD_VERSION}.0.tar.xz
    INSTALL_DIR ${EXTPREFIX_frameworks}
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${EXTPREFIX_frameworks}
               -DCMAKE_BUILD_TYPE=${GLOBAL_BUILD_TYPE}
               ${GLOBAL_PROFILE}
               -DCMAKE_SYSTEM_PREFIX_PATH=${EXTPREFIX}
               -DBUILD_TESTING=OFF
               -Wno-dev
    UPDATE_COMMAND ""
    ALWAYS 0
)

ExternalProject_Add(
    ext_kio
    DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}
    URL http://download.kde.org/stable/frameworks/${KD_VERSION}/kio-${KD_VERSION}.0.tar.xz
    INSTALL_DIR ${EXTPREFIX_frameworks}
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${EXTPREFIX_frameworks}
               -DCMAKE_BUILD_TYPE=${GLOBAL_BUILD_TYPE}
               ${GLOBAL_PROFILE}
               -DCMAKE_SYSTEM_PREFIX_PATH=${EXTPREFIX}
               -DBUILD_TESTING=OFF
               -Wno-dev
    UPDATE_COMMAND ""
    ALWAYS 0
)

ExternalProject_Add(
    ext_kwallet
    DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}
    URL http://download.kde.org/stable/frameworks/${KD_VERSION}/kwallet-${KD_VERSION}.0.tar.xz
    INSTALL_DIR ${EXTPREFIX_frameworks}
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${EXTPREFIX_frameworks}
               -DCMAKE_BUILD_TYPE=${GLOBAL_BUILD_TYPE}
               ${GLOBAL_PROFILE}
               -DCMAKE_SYSTEM_PREFIX_PATH=${EXTPREFIX}
               -DBUILD_TESTING=OFF
               -Wno-dev
               -DBUILD_KWALLETD=OFF
    UPDATE_COMMAND ""
    ALWAYS 0
)

ExternalProject_Add(
    ext_kparts
    DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}
    URL http://download.kde.org/stable/frameworks/${KD_VERSION}/kparts-${KD_VERSION}.0.tar.xz
    INSTALL_DIR ${EXTPREFIX_frameworks}
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${EXTPREFIX_frameworks}
               -DCMAKE_BUILD_TYPE=${GLOBAL_BUILD_TYPE}
               ${GLOBAL_PROFILE}
               -DCMAKE_SYSTEM_PREFIX_PATH=${EXTPREFIX}
               -DBUILD_TESTING=OFF
               -Wno-dev
               -DBUILD_KWALLETD=OFF
    UPDATE_COMMAND ""
    ALWAYS 0
)

ExternalProject_Add(
    ext_kdewebkit
    DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}
    URL http://download.kde.org/stable/frameworks/${KD_VERSION}/kdewebkit-${KD_VERSION}.0.tar.xz
    INSTALL_DIR ${EXTPREFIX_frameworks}
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${EXTPREFIX_frameworks}
               -DCMAKE_BUILD_TYPE=${GLOBAL_BUILD_TYPE}
               ${GLOBAL_PROFILE}
               -DCMAKE_SYSTEM_PREFIX_PATH=${EXTPREFIX}
               -DBUILD_TESTING=OFF
               -Wno-dev
               -DBUILD_KWALLETD=OFF
    UPDATE_COMMAND ""
    ALWAYS 0
)
