#!/bin/bash
filename=${1:-/etc/hosts}

if [ -r "$filename" ] && [ -s "$filename" ]; then
  md5sum $filename
else
  echo "$filename can not be processed"
fi

# Show the file if possible
ls -ld $filename 2>/dev/null
