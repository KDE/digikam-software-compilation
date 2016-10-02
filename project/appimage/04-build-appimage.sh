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
export LD_LIBRARY_PATH=/usr/lib64/:/usr/lib:/krita.appdir/usr/lib

git_pull_rebase_helper()
{
    git reset --hard HEAD
    git pull
}

# Make sure we build from the /, parts of this script depends on that. We also need to run as root...
cd  /

# Build AppImageKit
if [ ! -d AppImageKit ] ; then
  git clone  --depth 1 https://github.com/probonopd/AppImageKit.git /AppImageKit
fi

cd /AppImageKit/
git_pull_rebase_helper
./build.sh
cd /
