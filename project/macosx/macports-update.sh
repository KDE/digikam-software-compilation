#!/bin/sh

# Copyright (c) 2013-2014, Gilles Caulier, <caulier dot gilles at gmail dot com>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.

# XCode and Macports must be installed before to run this script.
# See http://www.macports.org/install.php for details.
# This script must be run as root through 'sudo' command.

port selfupdate
port upgrade outdated
