#!/bin/sh

# XCode and Macports must be installed before to run this script.
# See http://www.macports.org/install.php for details.
# This script must be run as root through 'sudo' command.

port -v selfupdate

# Packages to compile digiKam

port -v install qt4-mac +debug
port -v install qt4-mac-sqlite3-plugin +debug
port -v install kdelibs4 +debug
port -v install kde4-baseapps +debug
port -v install opencv +debug
port -v install marble +debug
port -v install oxygen-icons +debug
port -v install sane-backends +debug
port -v install libgpod +debug
port -v install libgphoto2 +debug
port -v install lensfun +debug
port -v install liblqr +debug
port -v install libraw +debug

# Extra packages to hack code

port -v install kdeartwork +debug
port -v install kate +debug
port -v install konsole +debug
port -v install kdemultimedia4 +debug
port -v install kdeutils4 +debug

port -v install valgrind +debug
port -v install mc +debug

# Packages not functionnals currently

#port -v install hugin-app +debug
#port -v install enblend +debug
