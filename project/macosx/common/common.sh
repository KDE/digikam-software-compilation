#!/bin/sh

# Copyright (c) 2013-2016, Gilles Caulier, <caulier dot gilles at gmail dot com>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.

########################################################################
# Check if run as root
ChecksRunAsRoot()
{

if [[ $EUID -ne 0 ]]; then
    echo "This script should be run as root using sudo command."
    exit 1
else
    echo "Check run as root passed..."
fi

}

########################################################################
# Check if Xcode Command Line tools are installed
ChecksXCodeCLI()
{

xcode-select --print-path

if [[ $? -ne 0 ]]; then
    echo "XCode CLI tools are not installed"
    echo "See http://www.macports.org/install.php for details."
    exit 1
else
    echo "Check XCode CLI tools passed..."
fi

}

########################################################################
# Check if Macports is installed
ChecksMacports()
{

which port

if [[ $? -ne 0 ]]; then
    echo "Macports is not installed"
    echo "See http://www.macports.org/install.php for details."
    exit 1
else
    echo "Check Macports passed..."
fi

}

########################################################################
# Check CPU core available (Linux or OSX)
ChecksCPUCores()
{

CPU_CORES=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || sysctl -n hw.ncpu)

echo "CPU Cores detected : $CPU_CORES"

}

########################################################################
# Performs All Checks
CommonChecks()
{

ChecksRunAsRoot
ChecksXCodeCLI
ChecksMacports

}

########################################################################
# For time execution measurement ; startup
StartScript()
{

BEGIN_SCRIPT=$(date +"%s")

}

########################################################################
# For time execution measurement : shutdown
TerminateScript()
{

TERMIN_SCRIPT=$(date +"%s")
difftimelps=$(($TERMIN_SCRIPT-$BEGIN_SCRIPT))
echo "Elaspsed time for script execution : $(($difftimelps / 3600 )) hours $((($difftimelps % 3600) / 60)) minutes $(($difftimelps % 60)) seconds"

}

########################################################################
# Set strings with detected OSX info :
#    $MAJOR_OSX_VERSION : detected OSX major ID (as 7 for 10.7 or 10 for 10.10)
#    $OSX_CODE_NAME     : detected OSX code name
OsxCodeName()
{

MAJOR_OSX_VERSION=$(sw_vers -productVersion | awk -F '.' '{print $1 "." $2}'| cut -d . -f 2)

if [[ $MAJOR_OSX_VERSION == "11" ]]
    then OSX_CODE_NAME="ElCapitan"
elif [[ $MAJOR_OSX_VERSION == "10" ]]
    then OSX_CODE_NAME="Yosemite"
elif [[ $MAJOR_OSX_VERSION == "9" ]]
    then OSX_CODE_NAME="Mavericks"
elif [[ $MAJOR_OSX_VERSION == "8" ]]
    then OSX_CODE_NAME="MountainLion"
elif [[ $MAJOR_OSX_VERSION == "7" ]]
    then OSX_CODE_NAME="Lion"
elif [[ $MAJOR_OSX_VERSION == "6" ]]
    then OSX_CODE_NAME="SnowLeopard"
elif [[ $MAJOR_OSX_VERSION == "5" ]]
    then OSX_CODE_NAME="Leopard"
elif [[ $MAJOR_OSX_VERSION == "4" ]]
    then OSX_CODE_NAME="Tiger"
elif [[ $MAJOR_OSX_VERSION == "3" ]]
    then OSX_CODE_NAME="Panther"
elif [[ $MAJOR_OSX_VERSION == "2" ]]
    then OSX_CODE_NAME="Jaguar"
elif [[ $MAJOR_OSX_VERSION == "1" ]]
    then OSX_CODE_NAME="Puma"
elif [[ $MAJOR_OSX_VERSION == "0" ]]
    then OSX_CODE_NAME="Cheetah"
fi

echo -e "---------- Detected OSX version 10.$MAJOR_OSX_VERSION and code name $OSX_CODE_NAME"

}

########################################################################
# Install extra KF5 frameworks library
# arguments : library name, additional cmake flags, download url, version 
#
InstallKDEExtraLib()
{

LIB_NAME=$1
ADDITIONAL_CMAKE_FLAGS=$2
LIB_URL=$3
LIB_VERSION=$4
FRAMEWORK=0

if [[ "$LIB_URL" == "" ]]; then
	LIB_URL=$KD_URL
    FRAMEWORK=1
fi

if [[ "$LIB_VERSION" == "" ]]; then
	LIB_VERSION=$KD_VERSION
fi

if [ $SILENT_OP -ne 0 ]; then
    VERBOSE_MAKE="-s"
    VERBOSE_CONF="2>&1 > /dev/null"
fi

if [ -d "$KD_BUILDTEMP" ] ; then
   echo "---------- Removing existing $KD_BUILDTEMP"
   rm -rf "$KD_BUILDTEMP"
fi

echo "---------- Creating $KD_BUILDTEMP"
mkdir "$KD_BUILDTEMP"

if [ $? -ne 0 ]; then
    echo "---------- Cannot create $KD_BUILDTEMP directory."
    echo "---------- Aborting..."
    exit;
fi

cd "$KD_BUILDTEMP"
echo -e "\n\n"

echo "---------- Downloading $LIB_NAME $LIB_VERSION"
echo "---------- URL: $LIB_URL/$LIB_VERSION/$LIB_NAME-$LIB_VERSION.tar.xz"

if [ $FRAMEWORK -ne 0 ]; then
	curl -L -o "$LIB_NAME-$LIB_VERSION.tar.xz" "$LIB_URL/$LIB_VERSION/$LIB_NAME-$LIB_VERSION.0.tar.xz" $VERBOSE_CONF
else
	curl -L -o "$LIB_NAME-$LIB_VERSION.tar.xz" "$LIB_URL/$LIB_NAME-$LIB_VERSION.tar.xz" $VERBOSE_CONF
fi

if [ $? -ne 0 ]; then
    echo "---------- Cannot download $LIB_NAME-$LIB_VERSION.tar.xz archive."
    echo "---------- Aborting..."
    exit;
fi

tar jxf $LIB_NAME-$LIB_VERSION.tar.xz
if [ $? -ne 0 ]; then
    echo "---------- Cannot extract $LIB_NAME-$LIB_VERSION.tar.xz archive."
    echo "---------- Aborting..."
    exit;
fi

if [ $FRAMEWORK -ne 0 ]; then
	cd $LIB_NAME-$LIB_VERSION.0
    cp -f $ORIG_WD/../../../bootstrap.macports $KD_BUILDTEMP/$LIB_NAME-$LIB_VERSION.0
else
	cd $LIB_NAME-$LIB_VERSION
    cp -f $ORIG_WD/../../../bootstrap.macports $KD_BUILDTEMP/$LIB_NAME-$LIB_VERSION
fi

if [ $? -ne 0 ]; then
    echo "---------- Cannot copy $LIB_NAME-$LIB_VERSION.tar.xz archive to temp dir."
    echo "---------- Aborting..."
    exit;
fi

echo -e "\n\n"
echo "---------- Configure $LIB_NAME with CXX extra flags : $EXTRA_CXX_FLAGS"

./bootstrap.macports "$INSTALL_PREFIX" "debugfull" "x86_64" "$EXTRA_CXX_FLAGS" $VERBOSE_CONF
if [ $? -ne 0 ]; then
    echo "---------- Cannot configure $LIB_NAME-$LIB_VERSION."
    echo "---------- Aborting..."
    exit;
fi

echo -e "\n\n"
echo "---------- Building $LIB_NAME $LIB_VERSION"
cd build

make $VERBOSE_MAKE -j$CPU_CORES
if [ $? -ne 0 ]; then
    echo "---------- Cannot compile $LIB_NAME-$LIB_VERSION."
    echo "---------- Aborting..."
    exit;
fi

echo -e "\n\n"
echo "---------- Installing $LIB_NAME $LIB_VERSION"
echo -e "\n\n"

make $VERBOSE_MAKE install/fast && cd "$ORIG_WD" && rm -rf "$DK_BUILDTEMP"
if [ $? -ne 0 ]; then
    echo "---------- Cannot install $LIB_NAME-$LIB_VERSION."
    echo "---------- Aborting..."
    exit;
fi

}

########################################################################
# Install Macports core packages before to compile digiKam
# See https://trac.macports.org/wiki/KDE for details
# Possible arguments : 
#     DISABLE_LIBRAW   : do not install LibRaw through Macports.
#     DISABLE_EXIV2    : do not install LibExiv2 through Macports.
#     DISABLE_LENSFUN  : do not install LibLensFun through Macports.
#     DISABLE_OPENCV   : do not install LibOpenCV through Macports.
#     CONTINUE_INSTALL : Continue aborted previous installation.
#
InstallCorePackages()
{

DISABLE_LIBRAW=0
DISABLE_EXIV2=0
DISABLE_LENSFUN=0
DISABLE_OPENCV=0
CONTINUE_INSTALL=0

for i in "$@" ; do
    if [[ $i == "DISABLE_LIBRAW" ]]; then
        echo "---------- LibRaw will not installed through Macports"
        DISABLE_LIBRAW=1
    elif [[ $i == "DISABLE_EXIV2" ]]; then
        echo "---------- Exiv2 will not installed through Macports"
        DISABLE_EXIV2=1
    elif [[ $i == "DISABLE_LENSFUN" ]]; then
        echo "---------- Lensfun will not installed through Macports"
        DISABLE_LENSFUN=1
    elif [[ $i == "DISABLE_OPENCV" ]]; then
        echo "---------- OpenCV will not installed through Macports"
        DISABLE_OPENCV=1
        echo "---------- Continue aborted previous installation"
        CONTINUE_INSTALL=1
    fi
done

OsxCodeName

if [[ $CONTINUE_INSTALL == 0 ]]; then

    # Remove kdelibs Avahi dependency. For details see bug https://bugs.kde.org/show_bug.cgi?id=257679#c6
    echo "---------- Removing Avahi dependency from kdelibs4"
    sed -e "s/port:avahi *//" -e "s/-DWITH_Avahi=ON/-DWITH_Avahi=OFF/" -i ".orig-avahi" "`port file kdelibs4`"

    if [[ $MAJOR_OSX_VERSION -lt 9 ]]; then

        # QtCurve and Akonadi do not compile fine with older clang compiler due to C++11 syntax
        # See details here : https://trac.macports.org/wiki/LibcxxOnOlderSystems
        echo "---------- Ajust C++11 compilation rules for older OSX release"
        echo -e "\ncxx_stdlib         libc++\nbuildfromsource    always\ndelete_la_files    yes\n" >> $INSTALL_PREFIX/etc/macports/macports.conf

    fi

fi

# With OSX less than El Capitan, we need a more recent Clang compiler than one provided by XCode.
if [[ $MAJOR_OSX_VERSION -lt 10 ]]; then

	echo "---------- Install more recent Clang compiler from Macports for specific ports"
	port install clang_select
	port install clang-3.4
	port select --set clang mp-clang-3.4
fi

# With older OSX release, there are some problem to link with cxx_stdlib option.
if [[ $MAJOR_OSX_VERSION -lt 8 ]]; then
    # ncurses fixes
    NCURSES_PORT_TMP=$INSTALL_PREFIX/var/tmp_ncurses
    if [ -d "$NCURSES_PORT_TMP" ] ; then
        rm -fr $NCURSES_PORT_TMP
    fi
    mkdir $NCURSES_PORT_TMP
    chown -R 777 $NCURSES_PORT_TMP
    cd $NCURSES_PORT_TMP

    svn co -r 131830 http://svn.macports.org/repository/macports/trunk/dports/devel/ncurses
    cd ncurses
    port install

    port install icu configure.compiler=macports-clang-3.4
fi

echo -e "\n"

port install dbus
port install qt5
port install qt5-sqlite-plugin
port install qt5-qtscript
port install cmake
port install opencv
port install libpng
port install libpgf
port install jpeg
port install tiff
port install boost
port install gettext
port install libusb
port install libgphoto2
port install jasper
port install liblqr
port install lcms2
port install eigen3
port install expat
port install libxml2
port install libxslt
port install docbook-xml
port install docbook-xsl
port install p5-uri

exit -1


port install strigi configure.compiler=macports-clang-3.4

if [[ $DISABLE_OPENCV == 0 ]]; then
    OPENCV_PORT_TMP=$INSTALL_PREFIX/var/tmp_opencv
    if [ -d "$OPENCV_PORT_TMP" ] ; then
        rm -fr $OPENCV_PORT_TMP
    fi
    mkdir $OPENCV_PORT_TMP
    chown -R 777 $OPENCV_PORT_TMP
    cd $OPENCV_PORT_TMP

    svn co -r 134472 http://svn.macports.org/repository/macports/trunk/dports/graphics/opencv
    cd opencv
    port install
fi

if [[ $DISABLE_LIBRAW == 0 ]]; then
    port install libraw
fi

if [[ $DISABLE_EXIV2 == 0 ]]; then
    port install exiv2
fi

# For core optional dependencies

if [[ $DISABLE_LENSFUN == 0 ]]; then
    port install lensfun
fi

# For Hugin

#port install wxWidgets-2.8

# For Kipi-plugins

port install qca
port install qjson
port install enblend
port install sane-backends

# For Color themes support

port install kdeartwork

# For Acqua style support (including KDE system settings)

port install kde4-workspace
port install qtcurve

# For video support

port install kdemultimedia4
port install ffmpegthumbs
port install phonon
port install gstreamer1-gst-libav
port install gstreamer1-gst-plugins-good

# For documentations
port install texlive-fonts-recommended
port install texlive-fontutils

}
