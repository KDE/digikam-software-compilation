#!/bin/sh

# XCode and Macports must be installed before to run this script.
# See http://www.macports.org/install.php for details.
# This script must be run as root through 'sudo' command.

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

