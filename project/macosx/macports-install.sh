#!/bin/sh

# XCode and Macports must be installed before. See http://www.macports.org/install.php for details
# This script must be run as root through sudo.

port -v selfupdate

port -v install qt4-mac +debug
port -v install qt4-mac-sqlite3-plugin +debug
port -v install kdelibs4 +debug
port -v install kde4-baseapps +debug
port -v install kdesdk4 +debug
port -v install opencv +debug
port -v install marble +debug
port -v install oxygen-icons +debug
port -v install sane-backends +debug
port -v install libgpod +debug
port -v install libgphoto2 +debug
port -v install lensfun +debug
port -v install liblqr +debug

port -v install hugin-app +debug
port -v install enblend +debug
