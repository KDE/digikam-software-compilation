#!/bin/sh

sudo port -v selfupdate

sudo port -v install qt4-mac +debug
sudo port -v install qt4-mac-sqlite3-plugin +debug
sudo port -v install kdelibs4 +debug
sudo port -v install kde4-baseapps +debug
sudo port -v install kdesdk4 +debug
sudo port -v install opencv +debug
sudo port -v install marble +debug
sudo port -v install oxygen-icons +debug
sudo port -v install sane-backends +debug
sudo port -v install libgpod +debug
sudo port -v install libgphoto2 +debug
sudo port -v install lensfun +debug
sudo port -v install liblqr +debug

sudo port -v install hugin-app +debug
sudo port -v install enblend +debug
