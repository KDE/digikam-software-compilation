#!/bin/sh

# Copyright (c) 2013-2015, Gilles Caulier, <caulier dot gilles at gmail dot com>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.

########################################################################
# Set common variables
CommonSetup()
{

# Directory where MacPorts will be built, and where it will be installed by packaging script
INSTALL_PREFIX="/opt/digikam"

# Uncomment this line to compile with debug symbols Macports variant
#DEBUG_SYMBOLS="+debug"

# digiKam version to build
DK_VERSION="4.10.0"

}

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
xcode-select -p

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
# Performs All Checks
CommonChecks()
{

CommonSetup
ChecksRunAsRoot
ChecksXCodeCLI
ChecksMacports

}

########################################################################
# Install Macports core packages to compile digiKam
# See https://trac.macports.org/wiki/KDE for details
InstallCorePackages()
{

port install qt4-mac ${DEBUG_SYMBOLS}
port install qt4-mac-sqlite3-plugin ${DEBUG_SYMBOLS}
port install kdelibs4 ${DEBUG_SYMBOLS}
port install kde4-baseapps ${DEBUG_SYMBOLS}
port install kde4-runtime ${DEBUG_SYMBOLS}
port install oxygen-icons ${DEBUG_SYMBOLS}
port install libpng ${DEBUG_SYMBOLS}
port install libpgf ${DEBUG_SYMBOLS}
port install libraw ${DEBUG_SYMBOLS}
port install jpeg ${DEBUG_SYMBOLS}
port install tiff ${DEBUG_SYMBOLS}
port install exiv2 ${DEBUG_SYMBOLS}
port install boost ${DEBUG_SYMBOLS}
port install opencv ${DEBUG_SYMBOLS}

# For core optional dependencies

port install gettext ${DEBUG_SYMBOLS}
port install libusb ${DEBUG_SYMBOLS}
port install libgphoto2 ${DEBUG_SYMBOLS}
port install marble ${DEBUG_SYMBOLS}
port install lensfun ${DEBUG_SYMBOLS}
port install jasper ${DEBUG_SYMBOLS}
port install liblqr ${DEBUG_SYMBOLS}
port install lcms2 ${DEBUG_SYMBOLS}
port install eigen3 ${DEBUG_SYMBOLS}
port install sqlite2 ${DEBUG_SYMBOLS}
port install baloo ${DEBUG_SYMBOLS}
port install shared-desktop-ontologies ${DEBUG_SYMBOLS}

# For Kipi-plugins

port install sane-backends ${DEBUG_SYMBOLS}
port install expat ${DEBUG_SYMBOLS}
port install libgpod ${DEBUG_SYMBOLS}
port install libxml2 ${DEBUG_SYMBOLS}
port install libxslt ${DEBUG_SYMBOLS}
port install qca ${DEBUG_SYMBOLS}
port install qjson ${DEBUG_SYMBOLS}
port install ImageMagick ${DEBUG_SYMBOLS}
port install glib2 ${DEBUG_SYMBOLS}

# For Color themes support

port install kdeartwork ${DEBUG_SYMBOLS}

# For Acqua style support (including KDE system settings)

port install kde4-workspace ${DEBUG_SYMBOLS}
port install qtcurve ${DEBUG_SYMBOLS}

# For video support

port install kdemultimedia4 ${DEBUG_SYMBOLS}
port install ffmpegthumbs ${DEBUG_SYMBOLS}
port install phonon ${DEBUG_SYMBOLS}
port install gstreamer1-gst-libav ${DEBUG_SYMBOLS}
port install gstreamer1-plugins-good ${DEBUG_SYMBOLS}

# For documentations
port install texlive-fonts-recommended ${DEBUG_SYMBOLS}
port install texlive-fontutils ${DEBUG_SYMBOLS}

}
