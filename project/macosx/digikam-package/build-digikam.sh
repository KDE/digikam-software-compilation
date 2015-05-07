#! /bin/bash
# Script to build digikam using MacPorts - 2015-04-16 

# Directiory where MacPorts will be built, and where it will be installed by
# packaging script
INSTALL_PREFIX="/opt/digikam"

# Temporary directory in which MacPorts will be built
MP_BUILDTEMP=~/mptemp

MP_URL="https://distfiles.macports.org/MacPorts/"
MP_VERSION="2.3.3"

ORIG_PATH="$PATH"
ORIG_WD="`pwd`"

echo -e "\n\n"

# (Delete and re-)Create MacPorts install directory 
if [ -d "$INSTALL_PREFIX" ] ; then
   echo "---------- Removing existing  $INSTALL_PREFIX"
   rm -rf "$INSTALL_PREFIX"
fi

echo "---------- Creating $INSTALL_PREFIX"
mkdir "$INSTALL_PREFIX"

# (Delete and re-)Create temporary MacPorts build directory
if [ -d "$MP_BUILDTEMP" ] ; then
   echo "---------- Removing existing $MP_BUILDTEMP" 
   rm -rf "$MP_BUILDTEMP"
fi

echo "---------- Creating $MP_BUILDTEMP"
mkdir "$MP_BUILDTEMP"

cd "$MP_BUILDTEMP"
echo -e "\n\n"

echo "---------- Downloading MacPorts $MP_VERSION"
curl -o "MacPorts-$MP_VERSION.tar.bz2" "$MP_URL/MacPorts-$MP_VERSION.tar.bz2"
tar jxvf MacPorts-$MP_VERSION.tar.bz2
cd MacPorts-$MP_VERSION
echo -e "\n\n"

echo "---------- Configuring MacPorts"
./configure --prefix="$INSTALL_PREFIX" \
	    --with-applications-dir="$INSTALL_PREFIX/Applications" \
	    --with-no-root-privileges \
	    --with-install-user="$(id -n -u)" \
	    --with-install-group="$(id -n -g)" 
echo -e "\n\n"

echo *** Building MacPorts
make 
echo -e "\n\n"

echo *** Installing MacPorts
echo -e "\n\n"
make install && cd "$ORIG_WD" && rm -rf "$MP_BUILDTEMP"

cat << EOF >> "$INSTALL_PREFIX/etc/macports/macports.conf"
+no_root -startupitem
startupitem_type none
startupitem_install no
EOF

export PATH=$INSTALL_PREFIX/bin:/$INSTALL_PREFIX/sbin:$ORIG_PATH

echo -e "\n"
echo "---------- Updating MacPorts"
port -v selfupdate
echo -e "\n"

#echo "---------- Modifying net-snmp portfile to install when not root"
#sed -e "/install.asroot/ s|yes|no|" -i ".orig" "`port file net-snmp`"

# Remove kdelibs avahi dependency  (https://bugs.kde.org/show_bug.cgi?id=257679)
#echo "---------- Removing Avahi depenency from kdelibs4"
#sed -e "s/port:avahi *//" -e "s/-DWITH_Avahi=ON/-DWITH_Avahi=OFF/" -i ".orig-avahi" "`port file kdelibs4`"

# Use custom digikam portfile if digikam-portfile/Portfile exists
[[ -f digikam-portfile/Portfile ]] && echo "*** Replacing digikam portfile with digikam-portfile/Portfile" && cp digikam-portfile/Portfile "`port file digikam`"

echo "*** Building digikam with Macports"

# Manual install of texlive-fonts-recommended & texlive-font-utils is
# required  to build docs
port -fv install texlive-fonts-recommended texlive-fontutils 

# External MySQL external database support is why I use digikam. Default 
# akonadi variant (mariadb55) breaks build due to conflict with mysql5x
port -fv install akonadi +mysql56 digikam +docs+mysql56_external+debug

export PATH=$ORIG_PATH
