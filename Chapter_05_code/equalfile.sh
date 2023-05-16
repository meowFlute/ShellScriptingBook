#!/bin/bash

file1=$1
file2=$2

ls -il $file1 $file2
if [ $file1 -ef $file2 ]; then
  echo "$file1 is the same file as $file2"
else
  echo "$file1 is not the same file as $file2"
  diff -q $file1 $file2 
  if [ "$?" -eq "0" ]; then
    echo "However, their contents are identical."
  fi
fi
