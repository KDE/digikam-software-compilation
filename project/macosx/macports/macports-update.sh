#!/bin/sh

# Copyright (c) 2013-2015, Gilles Caulier, <caulier dot gilles at gmail dot com>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.

# Pre-processing checks

. ../common/common.sh
StartScript
CommonChecks

# Update Macports binary

port selfupdate

# Update all already install packages

port upgrade outdated

TerminateScript
