#!/bin/bash

for file in file1.zip file2.zip file3.zip
do
  timeout -s 9 60 wget http://unreliable.example.com/${file}
  if [ "$?" -ne "0" ]; then
    echo "An error occurred when downloading $file"
  fi
done
