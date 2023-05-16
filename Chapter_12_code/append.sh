#!/bin/bash

LOGFILE=/tmp/log.txt

function showfile
{
  if [ -f "${1}" ]; then
    ls -l "${1}"
    echo "--- the contents are:"
    cat "${1}"
    echo "--- end of file."
  else
    echo "The file does not currently exist."
  fi
}

echo "Testing $LOGFILE for the first time."
showfile $LOGFILE

echo "Appending to $LOGFILE"
date >> $LOGFILE

echo "Testing $LOGFILE for the second time."
showfile $LOGFILE

sleep 10

echo "Appending to $LOGFILE again."
date >> $LOGFILE

echo "Testing $LOGFILE for the third and final time."
showfile $LOGFILE
