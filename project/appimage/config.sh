#!/bin/bash

# Copyright (c) 2013-2016, Gilles Caulier, <caulier dot gilles at gmail dot com>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.

########################################################################

# digiKam tarball information.
DK_URL="http://download.kde.org/stable/digikam"
# Location to build source code.
DK_BUILDTEMP=~/dktemp
# digiKam tarball information
DK_URL="http://download.kde.org/stable/digikam"
DK_BUILDTEMP=~/dktemp
# digiKam tag version from git. Official tarball do not include extra shared libraries.
# The list of tags can be listed with this url: https://quickgit.kde.org/?p=digikam.git&a=tags
# If you want to package current implemntation from git, use "master" as tag.
#DK_VERSION=v5.2.0
DK_VERSION=master
# Installer sub version to differentiates newer updates of the installer itself, even if the underlying application hasn’t changed.
DK_EPOCH="-01"
