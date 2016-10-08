#!/bin/bash

# Halt on errors
set -e

# Be verbose
set -x

# Now we are inside CentOS 6
grep -r "CentOS release 6" /etc/redhat-release || exit 1

# qjsonparser, used to add metadata to the plugins needs to work in a en_US.UTF-8 environment. That's
# not always set correctly in CentOS 6.7
export LC_ALL=en_US.UTF-8
export LANG=en_us.UTF-8

# Determine which architecture should be built
if [[ "$(arch)" = "i686" || "$(arch)" = "x86_64" ]] ; then
  ARCH=$(arch)
else
  echo "Architecture could not be determined"
  exit 1
fi

# if the library path doesn't point to our usr/lib, linking will be broken and we won't find all deps either
export LD_LIBRARY_PATH=/usr/lib64/:/usr/lib:/digikam.appdir/usr/lib

yum -y install epel-release

# we need to be up to date in order to install the xcb-keysyms dependency
yum -y update

# base dependencies and Qt5.
yum -y install wget \
               tar \
               bzip2 \
               gettext \
               zlib-devel \
               expat-devel \
               git \
               libtool \
               which \
               fuse \
               fuse-devel \
               libjpeg-devel \
               libpng-devel \
               automake \
               libtool-ltdl-devel \
               glib2-devel \
               glibc-headers \
               mysql-devel \
               openssl-devel \
               mesa-libEGL \
               cppunit-devel \
               cmake3 \
               glibc-headers \
               libstdc++-devel \
               gcc-c++ \
               freetype-devel \
               fontconfig-devel \
               libxml2-devel \
               libstdc++-devel \
               libXrender-devel \
               patch \
               xcb-util-keysyms-devel \
               libXi-devel \
               mesa-libGL-devel \
               mesa-libGLU-devel \
               libxcb \
               libxcb-devel \
               xcb-util \
               xcb-util-devel \
               glibc-devel \
               xkeyboard-config \
               libudev-devel \
               libicu-devel \
               gperf \
               ruby \
               jasper-devel \
               sqlite-devel \
               libusb-devel \
               libexif-devel \
               bison \
               flex \
               mc \
               dkms


# Newer compiler than what comes with CentOS 6
yum -y install centos-release-scl-rh
yum -y install devtoolset-4-gcc devtoolset-4-gcc-c++
. /opt/rh/devtoolset-4/enable

# remove system based devel package to prevent conflict with new one.
yum -y erase qt-devel boost-devel

# Workaround for: On CentOS 6, .pc files in /usr/lib/pkgconfig are not recognized
# However, this is where .pc files get installed when bulding libraries... (FIXME)
# I found this by comparing the output of librevenge's "make install" command
# between Ubuntu and CentOS 6
ln -sf /usr/share/pkgconfig /usr/lib/pkgconfig

# Make sure we build from the /, parts of this script depends on that. We also need to run as root...
cd /

# Create the build dir for the 3rdparty deps
if [ ! -d /b ] ; then
    mkdir /b
fi
if [ ! -d /d ] ; then
    mkdir /d
fi

# Build AppImageKit
if [ ! -d AppImageKit ] ; then
    git clone  --depth 1 https://github.com/probonopd/AppImageKit.git /AppImageKit
fi

cd /AppImageKit/
git_pull_rebase_helper
./build.sh
cd /
