#!/bin/sh

# XCode and Macports must be installed before to run this script.
# See http://www.macports.org/install.php for details.
# This script must be run as root through 'sudo' command.

port selfupdate
port upgrade outdated
