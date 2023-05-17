#!/bin/sh
while read -p "What file do you want to test? " filename
do
if [ ! -e "$filename" ]; then
  echo "The file does not exist."
  continue
fi

# Okay, the file exists.
  ls -ld $filename
  if [ -u $filename ]; then
    echo "$filename will run as user \"`stat --printf=%U $filename`\""
  fi
  if [ -g $filename ]; then
    echo "$filename will run as group \"`stat --printf=%G $filename`\""
  fi
done
