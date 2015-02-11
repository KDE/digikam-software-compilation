#!/bin/sh

grep -r "#include <k" *                    | \
   grep -v "#include <klocalizedstring.h>" | \
   grep -v "exiv"                          | \
   grep -v "dcraw"                         | \
   grep -v "config"                        | \
   grep -v "geomap"                        | \
   grep -v "kio"
