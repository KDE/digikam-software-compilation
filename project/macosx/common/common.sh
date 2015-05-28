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
# For time execution measurement ; startup
StartScript()
{

begin=$(date +"%s")

}

########################################################################
# For time execution measurement : shutdown
TerminateScript()
{

termin=$(date +"%s")
difftimelps=$(($termin-$begin))
echo "$(($difftimelps / 60)) minutes and $(($difftimelps % 60)) seconds elapsed for script execution."

}

########################################################################
# Install Macports core packages to compile digiKam
# See https://trac.macports.org/wiki/KDE for details
InstallCorePackages()
{

port install qt4-mac
port install qt4-mac-sqlite3-plugin
port install kdelibs4
port install kde4-baseapps
port install kde4-runtime
port install oxygen-icons
port install libpng
port install libpgf
port install libraw
port install jpeg
port install tiff
port install exiv2
port install boost
port install opencv

# For core optional dependencies

port install gettext
port install libusb
port install libgphoto2
port install marble
port install lensfun
port install jasper
port install liblqr
port install lcms2
port install eigen3
port install sqlite2

# For Kipi-plugins

port install sane-backends
port install expat
port install libgpod
port install libxml2
port install libxslt
port install qca
port install qjson
port install ImageMagick
port install glib2

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
