#!/bin/sh

# Copyright (c) 2013-2015, Gilles Caulier, <caulier dot gilles at gmail dot com>
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
# PerformsAllChecks
CommonChecks()
{

ChecksRunAsRoot
ChecksXCodeCLI
ChecksMacports

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
port install opencv
port install marble
port install oxygen-icons
port install sane-backends
port install libgpod
port install libgphoto2
port install lensfun
port install jpeg
port install tiff
port install jasper
port install boost
port install libpng
port install liblqr
port install libpgf
port install libraw
port install lcms2
port install eigen3
port install sqlite2
port install baloo

# For Kipi-plugins

port install expat
port install libgpod
port install libxml2
port install libxstl
port install qca
port install qjson
port install ImageMagick

# For Color themes support

port install kdeartwork

# For Acqua style support

port install kde4-workspace
port install qtcurve

# For video support

port install kdemultimedia4
port install ffmpegthumbs

# Manual install of texlive-fonts-recommended & texlive-font-utils is required to build docs
port install texlive-fonts-recommended
port install texlive-fontutils
}
