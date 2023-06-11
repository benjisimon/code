#!/bin/bash

##
## Download all the files in sources.txt
##

root=$(dirname $0)
dest=$root/pdf

mkdir -p $dest
cd $dest

cat ../sources.txt | while read line ; do
  url=$(echo $line | cut -d'|' -f 1)
  if [ -z "$url" ] ; then
    continue
  fi

  label=$(echo $line | cut -d'|' -s -f 2)
  if [ -n "$label" ] ; then
    file=$(echo  $label | sed 's/ /_/g').pdf
  else
    file=$(basename $url)
  fi

  if [ ! -f "$file" ] ; then
    echo "$file ($url)"
    curl -s $url > $file
  fi
done
