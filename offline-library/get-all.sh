#!/bin/bash

##
## Download all the files in sources.txt
##

root=$(dirname $0)
dest=$root/pdf

mkdir -p $dest
cd $dest

cat ../sources.txt | while read url ; do
  file=$(basename $url)
  if [ ! -f "$file" ] ; then
    wget $url
  fi
done
