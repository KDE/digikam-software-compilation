#!/bin/sh

# See this url to see how to prepare your computer with Coverity SCAN tool:
# http://scan.coverity.com/self-build/

cd ../../build/
make clean
cov-build --dir cov-int --tmpdir ~/tmp make
tar czvf myproject.tgz cov-int

echo "Coverity Scan tarball 'myproject.tgz' uploading in progress..."

curl --form file=@myproject.tgz \
     --form project=digiKam \
     --form password=$digiKamCoverityPassword \
     --form email=caulier.gilles@gmail.com \
     --form version=git-master \
     --form description="Git/Master from KDE repository" \
     http://scan5.coverity.com/cgi-bin/upload.py

echo "Coverity Scan tarball 'myproject.tgz' is uploaded and ready for analyse."

