#!/bin/sh

# See this url to see how to prepare your computer with Coverity SCAN tool:
# http://scan.coverity.com/self-build/

cd ../../build/
cov-build --dir cov-int --tmpdir ~/tmp make
tar czvf myproject.tgz cov-int

echo "Coverity Scan tarball 'myproject.tgz' ready to be uploaded at http://scan.coverity.com/upload.html fpr analyse"
