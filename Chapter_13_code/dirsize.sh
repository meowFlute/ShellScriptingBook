#!/bin/bash

cd "${1:-.}"
if [ "$?" -ne "0" ]; then
  echo "Error: Failed to change to directory $1"
  exit 2
fi
echo "The largest files/directories in $1 are:"
du -sh * | sort -hr | head | cat -n -
