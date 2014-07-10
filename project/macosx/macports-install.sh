#!/bin/sh

# Copyright (c) 2013-2014, Gilles Caulier, <caulier dot gilles at gmail dot com>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.

# XCode must be installed before to run this script.
# See http://www.macports.org/install.php for details.
# This script must be run as root through 'sudo' command.

# Install Macports package

curl -O http://distfiles.macports.org/MacPorts/MacPorts-2.3.1-10.9-Mavericks.pkg
installer -verbose -pkg MacPorts-2.3.1-10.9-Mavericks.pkg -target /

# update macport

port -v selfupdate

# Packages to compile digiKam

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
port install liblqr 
port install libraw 
port install mysql5

# Extra packages to hack code

port install kdeartwork 
port install kate 
port install konsole 
port install kdemultimedia4 
port install kdeutils4
port install eigen3
port install sqlite2
port install mc

# Packages not functionnals currently

#port -v install hugin-app 
#port -v install enblend
#port -v install valgrind 
