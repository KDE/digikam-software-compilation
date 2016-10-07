#!/bin/bash

. ./config.sh

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

. /opt/rh/devtoolset-4/enable

git_pull_rebase_helper()
{
    git reset --hard HEAD
    git pull
}

# Make sure we build from the /, parts of this script depends on that. We also need to run as root...
cd /

# Build AppImageKit
if [ ! -d AppImageKit ] ; then
    git clone  --depth 1 https://github.com/probonopd/AppImageKit.git /AppImageKit
fi

cd /AppImageKit/
git_pull_rebase_helper
./build.sh
cd /

# Prepare the install location
rm -rf /digikam.appdir/ || true
mkdir -p /digikam.appdir/usr/bin

# make sure lib and lib64 are the same thing
mkdir -p /digikam.appdir/usr/lib
cd  /digikam.appdir/usr
ln -s lib lib64

cd /digikam.appdir

# FIXME: How to find out which subset of plugins is really needed? I used strace when running the binary
cp -r /usr/plugins ./usr/bin/
# copy the Qt translation
cp -r /usr/translations ./usr

cp $(ldconfig -p | grep /usr/lib64/libsasl2.so.2 | cut -d ">" -f 2 | xargs) ./usr/lib/
cp $(ldconfig -p | grep /usr/lib64/libGL.so.1 | cut -d ">" -f 2 | xargs) ./usr/lib/ # otherwise segfaults!?
cp $(ldconfig -p | grep /usr/lib64/libGLU.so.1 | cut -d ">" -f 2 | xargs) ./usr/lib/ # otherwise segfaults!?
# Fedora 23 seemed to be missing SOMETHING from the Centos 6.7. The only message was:
# This application failed to start because it could not find or load the Qt platform plugin "xcb".
# Setting export QT_DEBUG_PLUGINS=1 revealed the cause.
# QLibraryPrivate::loadPlugin failed on "/usr/lib64/qt5/plugins/platforms/libqxcb.so" : 
# "Cannot load library /usr/lib64/qt5/plugins/platforms/libqxcb.so: (/lib64/libEGL.so.1: undefined symbol: drmGetNodeTypeFromFd)"
# Which means that we have to copy libEGL.so.1 in too
cp $(ldconfig -p | grep /usr/lib64/libEGL.so.1 | cut -d ">" -f 2 | xargs) ./usr/lib/ # Otherwise F23 cannot load the Qt platform plugin "xcb"
# let's not copy xcb itself, that breaks on dri3 systems https://bugs.kde.org/show_bug.cgi?id=360552
#cp $(ldconfig -p | grep libxcb.so.1 | cut -d ">" -f 2 | xargs) ./usr/lib/ 
cp $(ldconfig -p | grep /usr/lib64/libfreetype.so.6 | cut -d ">" -f 2 | xargs) ./usr/lib/ # For Fedora 20

cp /usr/bin/digikam ./usr/bin
cp /usr/bin/showfoto ./usr/bin

ldd usr/bin/digikam | grep "=>" | awk '{print $3}' | xargs -I '{}' cp -v '{}' ./usr/lib || true
ldd usr/bin/showfoto | grep "=>" | awk '{print $3}' | xargs -I '{}' cp -v '{}' ./usr/lib || true
ldd usr/lib64/libdigikam*.so  | grep "=>" | awk '{print $3}' | xargs -I '{}' cp -v '{}' ./usr/lib || true
ldd usr/plugins/kipiplugin*.so  | grep "=>" | awk '{print $3}' | xargs -I '{}' cp -v '{}' ./usr/lib || true
#ldd usr/lib64/plugins/imageformats/*.so  | grep "=>" | awk '{print $3}' | xargs -I '{}' cp -v '{}' ./usr/lib || true

ldd usr/bin/plugins/platforms/libqxcb.so | grep "=>" | awk '{print $3}'  |  xargs -I '{}' cp -v '{}' ./usr/lib || true

# Copy in the indirect dependencies
FILES=$(find . -type f -executable)

for FILE in $FILES ; do
    ldd "${FILE}" | grep "=>" | awk '{print $3}' | xargs -I '{}' cp -v '{}' usr/lib || true
done

#DEPS=""
#for FILE in $FILES ; do
#  ldd "${FILE}" | grep "=>" | awk '{print $3}' | xargs -I '{}' echo '{}' > DEPSFILE
#done
#DEPS=$(cat DEPSFILE  |sort | uniq)
#for FILE in $DEPS ; do
#  if [ -f $FILE ] ; then
#    echo $FILE
#    cp --parents -rfL $FILE ./
#  fi
#done
#rm -f DEPSFILE


# The following are assumed to be part of the base system
rm -f usr/lib/libcom_err.so.2 || true
rm -f usr/lib/libcrypt.so.1 || true
rm -f usr/lib/libdl.so.2 || true
rm -f usr/lib/libexpat.so.1 || true
#rm -f usr/lib/libfontconfig.so.1 || true
rm -f usr/lib/libgcc_s.so.1 || true
rm -f usr/lib/libglib-2.0.so.0 || true
rm -f usr/lib/libgpg-error.so.0 || true
rm -f usr/lib/libgssapi_krb5.so.2 || true
rm -f usr/lib/libgssapi.so.3 || true
rm -f usr/lib/libhcrypto.so.4 || true
rm -f usr/lib/libheimbase.so.1 || true
rm -f usr/lib/libheimntlm.so.0 || true
rm -f usr/lib/libhx509.so.5 || true
rm -f usr/lib/libICE.so.6 || true
rm -f usr/lib/libidn.so.11 || true
rm -f usr/lib/libk5crypto.so.3 || true
rm -f usr/lib/libkeyutils.so.1 || true
rm -f usr/lib/libkrb5.so.26 || true
rm -f usr/lib/libkrb5.so.3 || true
rm -f usr/lib/libkrb5support.so.0 || true
# rm -f usr/lib/liblber-2.4.so.2 || true # needed for debian wheezy
# rm -f usr/lib/libldap_r-2.4.so.2 || true # needed for debian wheezy
rm -f usr/lib/libm.so.6 || true
rm -f usr/lib/libp11-kit.so.0 || true
rm -f usr/lib/libpcre.so.3 || true
rm -f usr/lib/libpthread.so.0 || true
rm -f usr/lib/libresolv.so.2 || true
rm -f usr/lib/libroken.so.18 || true
rm -f usr/lib/librt.so.1 || true
rm -f usr/lib/libsasl2.so.2 || true
rm -f usr/lib/libSM.so.6 || true
rm -f usr/lib/libusb-1.0.so.0 || true
rm -f usr/lib/libuuid.so.1 || true
rm -f usr/lib/libwind.so.0 || true
rm -f usr/lib/libfontconfig.so.* || true

# Remove these libraries, we need to use the system versions; this means 11.04 is not supported (12.04 is our baseline)
rm -f usr/lib/libGL.so.* || true
rm -f usr/lib/libdrm.so.* || true
rm -f usr/lib/libX11.so.* || true
#rm -f usr/lib/libz.so.1 || true

# These seem to be available on most systems but not Ubuntu 11.04
# rm -f usr/lib/libffi.so.6 usr/lib/libGL.so.1 usr/lib/libglapi.so.0 usr/lib/libxcb.so.1 usr/lib/libxcb-glx.so.0 || true

# Delete potentially dangerous libraries
rm -f usr/lib/libstdc* usr/lib/libgobject* usr/lib/libc.so.* || true
rm -f usr/lib/libxcb.so.1

# Do NOT delete libX* because otherwise on Ubuntu 11.04:
# loaded library "Xcursor" malloc.c:3096: sYSMALLOc: Assertion (...) Aborted

# We don't bundle the developer stuff
rm -rf usr/include || true
rm -rf usr/lib/cmake3 || true
rm -rf usr/lib/pkgconfig || true
rm -rf usr/share/ECM/ || true
rm -rf usr/share/gettext || true
rm -rf usr/share/pkgconfig || true

strip usr/lib/kipiplugin_* usr/bin/* usr/lib/* || true

# Since we set /digikam.appdir as the prefix, we need to patch it away too (FIXME)
# Probably it would be better to use /app as a prefix because it has the same length for all apps
cd usr/ ; find . -type f -exec sed -i -e 's|/digikam.appdir/usr/|./././././././././|g' {} \; ; cd  ..

# On openSUSE Qt is picking up the wrong libqxcb.so
# (the one from the system when in fact it should use the bundled one) - is this a Qt bug?
# Also, Krita has a hardcoded /usr which we patch away
cd usr/ ; find . -type f -exec sed -i -e 's|/usr|././|g' {} \; ; cd ..

# We do not bundle this, so let's not search that inside the AppImage. 
# Fixes "Qt: Failed to create XKB context!" and lets us enter text
sed -i -e 's|././/share/X11/|/usr/share/X11/|g' ./usr/bin/plugins/platforminputcontexts/libcomposeplatforminputcontextplugin.so
sed -i -e 's|././/share/X11/|/usr/share/X11/|g' ./usr/lib/libQt5XcbQpa.so.5

# Workaround for:
# D-Bus library appears to be incorrectly set up;
# failed to read machine uuid: Failed to open
# The file is more commonly in /etc/machine-id
# sed -i -e 's|/var/lib/dbus/machine-id|//././././etc/machine-id|g' ./usr/lib/libdbus-1.so.3
# or
rm -f ./usr/lib/libdbus-1.so.3 || true

cp ../AppImageKit/AppRun .
cp /usr/share/applications/org.kde.digikam.desktop digikam.desktop
cp /usr/share/icons/hicolor/64x64/apps/digikam.png digikam.png
cp /usr/share/applications/org.kde.showfoto.desktop showfoto.desktop
cp /usr/share/icons/hicolor/64x64/apps/showfoto.png showfoto.png

# replace digikam with the lib-checking startup script.
#cd /digikam.appdir/usr/bin
#mv digikam digikam.real
#wget https://raw.githubusercontent.com/boudewijnrempt/AppImages/master/recipes/digikam/digikam
#chmod a+rx digikam
cd / 

APP=digikam

# Source functions
wget -q https://github.com/probonopd/AppImages/raw/master/functions.sh -O ./functions.sh
. ./functions.sh

# Install desktopintegration in usr/bin/digikam.wrapper -- feel free to edit it
cd /digikam.appdir
get_desktopintegration digikam
get_desktopintegration showfoto

cd /

VERSION=$DK_VERSION
echo $VERSION

if [[ "$ARCH" = "x86_64" ]] ; then
        APPIMAGE=$APP"-"$VERSION"-x86_64.appimage"
fi
if [[ "$ARCH" = "i686" ]] ; then
        APPIMAGE=$APP"-"$VERSION"-i386.appimage"
fi
echo $APPIMAGE

mkdir -p /out

rm -f /out/*.AppImage || true
AppImageKit/AppImageAssistant.AppDir/package /digikam.appdir/ /out/$APPIMAGE

chmod a+rwx /out/$APPIMAGE # So that we can edit the AppImage outside of the Docker container

cd /digikam.appdir
mv AppRun digikam
cd /
mv digikam.appdir "$APP"-"$VERSION"-x86_64
tar -czf "$APP"-"$VERSION"-x86_64.tgz "$APP"-"$VERSION"-x86_64
