SET(EXTPREFIX_frameworks "${EXTPREFIX}" )

#InstallKDEExtraLib "solid"               ""                                                 "-DBUILD_TESTING=OFF -Wno-dev"
#InstallKDEExtraLib "threadweaver"        ""                                                 "-DBUILD_TESTING=OFF -Wno-dev"
#InstallKDEExtraLib "karchive"            ""                                                 "-DBUILD_TESTING=OFF -Wno-dev"
#InstallKDEExtraLib "kdbusaddons"         ""                                                 "-DBUILD_TESTING=OFF -Wno-dev"
#InstallKDEExtraLib "ki18n"               ""                                                 "-DBUILD_TESTING=OFF -Wno-dev"
#InstallKDEExtraLib "kcrash"              ""                                                 "-DBUILD_TESTING=OFF -Wno-dev"
#InstallKDEExtraLib "kcodecs"             ""                                                 "-DBUILD_TESTING=OFF -Wno-dev"
#InstallKDEExtraLib "kauth"               ""                                                 "-DBUILD_TESTING=OFF -Wno-dev"
#InstallKDEExtraLib "kguiaddons"          ""                                                 "-DBUILD_TESTING=OFF -Wno-dev"
#InstallKDEExtraLib "kwidgetsaddons"      ""                                                 "-DBUILD_TESTING=OFF -Wno-dev"
#InstallKDEExtraLib "kitemviews"          ""                                                 "-DBUILD_TESTING=OFF -Wno-dev"
#InstallKDEExtraLib "kcompletion"         ""                                                 "-DBUILD_TESTING=OFF -Wno-dev"
#InstallKDEExtraLib "kconfigwidgets"      ""                                                 "-DBUILD_TESTING=OFF -Wno-dev"
#InstallKDEExtraLib "kiconthemes"         ""                                                 "-DBUILD_TESTING=OFF -Wno-dev"
#InstallKDEExtraLib "kservice"            ""                                                 "-DBUILD_TESTING=OFF -Wno-dev"
#InstallKDEExtraLib "kglobalaccel"        ""                                                 "-DBUILD_TESTING=OFF -Wno-dev"
#InstallKDEExtraLib "kxmlgui"             "$ORIG_WD/patches/kxmlgui-drop-ktextwidgets.patch" "-DBUILD_TESTING=OFF -Wno-dev"
#InstallKDEExtraLib "kbookmarks"          ""                                                 "-DBUILD_TESTING=OFF -Wno-dev"
#InstallKDEExtraLib "kimageformats"       ""                                                 "-DBUILD_TESTING=OFF -Wno-dev"

set(KD_VERSION 5.26)

ExternalProject_Add(
    ext_extra_cmake_modules
    DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}
    URL http://download.kde.org/stable/frameworks/${KD_VERSION}/extra-cmake-modules-${KD_VERSION}.0.zip
    PATCH_COMMAND ${PATCH_COMMAND} -p1 -i ${CMAKE_CURRENT_SOURCE_DIR}/ecm_install_to_share.diff
    INSTALL_DIR ${EXTPREFIX_frameworks}
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${EXTPREFIX_frameworks}
               -DCMAKE_BUILD_TYPE=${GLOBAL_BUILD_TYPE} 
                ${GLOBAL_PROFILE}
                -DCMAKE_SYSTEM_PREFIX_PATH=${EXTPREFIX} 
                -DBUILD_TESTING=false
    UPDATE_COMMAND ""
    ALWAYS 0
)

#    URL_MD5 e0c19ba97ebd964f9bdc9110c64ce96a

ExternalProject_Add(
    ext_kconfig
    DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}
    URL http://download.kde.org/stable/frameworks/5.24/kconfig-5.24.0.zip
    URL_MD5 f87ecff795eb76e4ec6561758a5baf87
    PATCH_COMMAND ${PATCH_COMMAND} -p1 -i ${CMAKE_CURRENT_SOURCE_DIR}/kconfig.diff
    INSTALL_DIR ${EXTPREFIX_frameworks}
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${EXTPREFIX_frameworks}
            -DCMAKE_BUILD_TYPE=${GLOBAL_BUILD_TYPE} 
                ${GLOBAL_PROFILE}
                -DCMAKE_SYSTEM_PREFIX_PATH=${EXTPREFIX} 
                -DBUILD_TESTING=false
    UPDATE_COMMAND ""
    ALWAYS 0
    DEPENDS ext_karchive
)

ExternalProject_Add(
    ext_breeze-icons
    DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}
    URL http://download.kde.org/stable/frameworks/5.24/breeze-icons-5.24.0.zip
    URL_MD5 f87ecff795eb76e4ec6561758a5baf87
    PATCH_COMMAND ${PATCH_COMMAND} -p1 -i ${CMAKE_CURRENT_SOURCE_DIR}/kconfig.diff
    INSTALL_DIR ${EXTPREFIX_frameworks}
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${EXTPREFIX_frameworks}
            -DCMAKE_BUILD_TYPE=${GLOBAL_BUILD_TYPE} 
                ${GLOBAL_PROFILE}
                -DCMAKE_SYSTEM_PREFIX_PATH=${EXTPREFIX} 
                -DBUILD_TESTING=false
    UPDATE_COMMAND ""
    ALWAYS 0
)

ExternalProject_Add(
    ext_kwindowsystem
    DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}
    URL http://download.kde.org/stable/frameworks/5.24/kwindowsystem-5.24.0.zip
    URL_MD5 5915e4f63ded983af6db7db3a6cbae1a
    INSTALL_DIR ${EXTPREFIX_frameworks}
    PATCH_COMMAND ${PATCH_COMMAND} -p1 -i ${CMAKE_CURRENT_SOURCE_DIR}/kwindowsystem-x11.diff
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${EXTPREFIX_frameworks}
            -DCMAKE_BUILD_TYPE=${GLOBAL_BUILD_TYPE} 
                ${GLOBAL_PROFILE}
                -DCMAKE_SYSTEM_PREFIX_PATH=${EXTPREFIX} 
                -DBUILD_TESTING=false
    UPDATE_COMMAND ""
    ALWAYS 0
    DEPENDS ext_kimageformats
)

ExternalProject_Add(
    ext_kcoreaddons
    DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}
    URL http://download.kde.org/stable/frameworks/5.24/kcoreaddons-5.24.0.zip
    URL_MD5 2885878625b19ad0300ef3770b897112
    INSTALL_DIR ${EXTPREFIX_frameworks}
    PATCH_COMMAND ${PATCH_COMMAND} -p1 -i ${CMAKE_CURRENT_SOURCE_DIR}/desktoptojson.diff
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${EXTPREFIX_frameworks}
            -DCMAKE_BUILD_TYPE=${GLOBAL_BUILD_TYPE} 
                ${GLOBAL_PROFILE}
                -DCMAKE_SYSTEM_PREFIX_PATH=${EXTPREFIX} 
                -DBUILD_TESTING=false
    UPDATE_COMMAND ""
    ALWAYS 0
    DEPENDS ext_kcompletion
)

ExternalProject_Add(
    ext_karchive
    DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}
    URL http://download.kde.org/stable/frameworks/5.24/karchive-5.24.0.zip
    URL_MD5 739843accfe9bd85ab2f1582722cf01e
    INSTALL_DIR ${EXTPREFIX_frameworks}
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${EXTPREFIX_frameworks}
               -DCMAKE_BUILD_TYPE=${GLOBAL_BUILD_TYPE} 
                ${GLOBAL_PROFILE}
                -DCMAKE_SYSTEM_PREFIX_PATH=${EXTPREFIX} 
                -DBUILD_TESTING=false
    UPDATE_COMMAND ""
    ALWAYS 0
    DEPENDS ext_extra_cmake_modules
)


ExternalProject_Add(
    ext_kwidgetsaddons
    DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}
    URL http://download.kde.org/stable/frameworks/5.24/kwidgetsaddons-5.24.0.zip
    URL_MD5 0e399b427814a4814c65a3cf407f9d79
    INSTALL_DIR ${EXTPREFIX_frameworks}
    PATCH_COMMAND ${PATCH_COMMAND} -p1 -i ${CMAKE_CURRENT_SOURCE_DIR}/kwidgetsaddons.diff
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${EXTPREFIX_frameworks}
            -DCMAKE_BUILD_TYPE=${GLOBAL_BUILD_TYPE} 
                ${GLOBAL_PROFILE}
                -DCMAKE_SYSTEM_PREFIX_PATH=${EXTPREFIX} 
                -DBUILD_TESTING=false
    UPDATE_COMMAND ""
    ALWAYS 0
    DEPENDS ext_kconfig
)


ExternalProject_Add(
    ext_kcompletion
    DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}
    URL http://download.kde.org/stable/frameworks/5.24/kcompletion-5.24.0.zip
    URL_MD5 e8764251ab45005aa81dba242852300c
    INSTALL_DIR ${EXTPREFIX_frameworks}
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${EXTPREFIX_frameworks}
            -DCMAKE_BUILD_TYPE=${GLOBAL_BUILD_TYPE} 
                ${GLOBAL_PROFILE}
                -DCMAKE_SYSTEM_PREFIX_PATH=${EXTPREFIX} 
                -DBUILD_TESTING=false
    UPDATE_COMMAND ""
    ALWAYS 0
    DEPENDS ext_kwidgetsaddons
)

ExternalProject_Add(
    ext_kguiaddons
    DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}
    URL http://download.kde.org/stable/frameworks/5.24/kguiaddons-5.24.0.zip
    URL_MD5 9bdadbc57d0634816ef80ee9798c3d6c
    INSTALL_DIR ${EXTPREFIX_frameworks}
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${EXTPREFIX_frameworks}
            -DCMAKE_BUILD_TYPE=${GLOBAL_BUILD_TYPE} 
                ${GLOBAL_PROFILE}
                -DCMAKE_SYSTEM_PREFIX_PATH=${EXTPREFIX} 
                -DBUILD_TESTING=false
    UPDATE_COMMAND ""
    ALWAYS 0
    DEPENDS ext_kcoreaddons
)


ExternalProject_Add(
    ext_ki18n
    DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}
        URL http://download.kde.org/stable/frameworks/5.17/ki18n-5.17.0.zip
    URL_MD5 7d60380d09f98defbf878ea9daba0fbb
    INSTALL_DIR ${EXTPREFIX_frameworks}
    PATCH_COMMAND ${PATCH_COMMAND} -p1 -i ${CMAKE_CURRENT_SOURCE_DIR}/ki18n.diff
          COMMAND ${PATCH_COMMAND} -p1 -i ${CMAKE_CURRENT_SOURCE_DIR}/ki18n-appdatalocation.diff
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${EXTPREFIX_frameworks}
            -DCMAKE_BUILD_TYPE=${GLOBAL_BUILD_TYPE} 
                ${GLOBAL_PROFILE}
                -DCMAKE_SYSTEM_PREFIX_PATH=${EXTPREFIX} 
                -DBUILD_TESTING=false
    UPDATE_COMMAND ""
    ALWAYS 0
    DEPENDS ext_kguiaddons
)


ExternalProject_Add(
    ext_kitemmodels
    DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}
    URL http://download.kde.org/stable/frameworks/5.24/kitemmodels-5.24.0.zip
    URL_MD5 ff41589f48395fc01d5fc7887593779d
    INSTALL_DIR ${EXTPREFIX_frameworks}
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${EXTPREFIX_frameworks}
            -DCMAKE_BUILD_TYPE=${GLOBAL_BUILD_TYPE} 
                ${GLOBAL_PROFILE}
                -DCMAKE_SYSTEM_PREFIX_PATH=${EXTPREFIX} 
                -DBUILD_TESTING=false
    UPDATE_COMMAND ""
    ALWAYS 0
    DEPENDS ext_ki18n
)

ExternalProject_Add(
    ext_kitemviews
    DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}
    URL http://download.kde.org/stable/frameworks/5.24/kitemviews-5.24.0.zip
    URL_MD5 33f638d027a3011a6a69f7484eee3287
    INSTALL_DIR ${EXTPREFIX_frameworks}
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${EXTPREFIX_frameworks}
            -DCMAKE_BUILD_TYPE=${GLOBAL_BUILD_TYPE} 
                ${GLOBAL_PROFILE}
                -DCMAKE_SYSTEM_PREFIX_PATH=${EXTPREFIX} 
                -DBUILD_TESTING=false
    UPDATE_COMMAND ""
    ALWAYS 0
    DEPENDS ext_kitemmodels
)

ExternalProject_Add(
    ext_kimageformats
    DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}
    URL http://download.kde.org/stable/frameworks/5.24/kimageformats-5.24.0.zip
    URL_MD5 c1964516bcb2bfe882858f0c0913deb5
    INSTALL_DIR ${EXTPREFIX_frameworks}
    PATCH_COMMAND ${PATCH_COMMAND} -p1 -i ${CMAKE_CURRENT_SOURCE_DIR}/kimageformats.diff
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${EXTPREFIX_frameworks}
            -DCMAKE_BUILD_TYPE=${GLOBAL_BUILD_TYPE} 
                ${GLOBAL_PROFILE}
                -DCMAKE_SYSTEM_PREFIX_PATH=${EXTPREFIX} 
                -DBUILD_TESTING=false
    UPDATE_COMMAND ""
    ALWAYS 0
    DEPENDS ext_kitemviews
)


ExternalProject_Add(
    ext_kcrash
    DOWNLOAD_DIR ${EXTERNALS_DOWNLOAD_DIR}
    URL http://download.kde.org/stable/frameworks/5.24/kcrash-5.24.0.zip
    URL_MD5 a2e41e6650105fc3ac8fbd44afbae4fe
    INSTALL_DIR ${EXTPREFIX_frameworks}
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${EXTPREFIX_frameworks}
            -DCMAKE_BUILD_TYPE=${GLOBAL_BUILD_TYPE} 
                ${GLOBAL_PROFILE}
                -DCMAKE_SYSTEM_PREFIX_PATH=${EXTPREFIX} 
                -DBUILD_TESTING=false
    UPDATE_COMMAND ""
    ALWAYS 0
    DEPENDS ext_kwindowsystem
)
