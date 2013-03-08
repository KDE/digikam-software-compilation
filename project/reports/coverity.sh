#!/bin/sh

# See this url to see how to prepare your computer with Coverity SCAN tool:
# http://scan.coverity.com/self-build/

cd ../..

# Manage build sub-dir
if [ -d "build" ]; then
    rm -rfv ./build
fi

./bootstrap.linux

cd ./build

cov-build --dir cov-int --tmpdir ~/tmp make
tar czvf myproject.tgz cov-int

echo "Coverity Scan tarball 'myproject.tgz' uploading in progress..."

nslookup scan5.coverity.com

curl -v --form file=@myproject.tgz \
     --form project=digiKam \
     --form password=$digiKamCoverityPassword \
     --form email=caulier.gilles@gmail.com \
     --form version=git-master \
     --form description="Git/Master from KDE repository - digiKam branch 'tableview' - libkface branch 'opentld'" \
     http://scan5.coverity.com/cgi-bin/upload.py

echo "Coverity Scan tarball 'myproject.tgz' is uploaded and ready for analyse."

