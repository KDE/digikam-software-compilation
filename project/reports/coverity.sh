#!/bin/sh

cd ../../build/
cov-build --dir cov-int --tmpdir ~/tmp make
tar czvf myproject.tgz cov-int
