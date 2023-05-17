#!/bin/bash
LOGFILE=/tmp/iso.md5

> $LOGFILE
find /iso -type f -name "*.iso*" -print | while read filename
do
  echo "Checking md5sum of $filename"
  md5sum "$filename" | tee -a $LOGFILE
done
