#!/bin/bash

function trimline()
{
  MAXLEN=$((LINELEN - 3)) # allow space for " \ " at end of line
  if [ "${#1}" -le "${LINELEN}" ]; then
    echo "$1"
  else
    echo "${1:0:${MAXLEN}} \\"
    trimline "${1:${MAXLEN}}"
  fi
}

LINELEN=${1:-80} # default to 80 columns
while read myline
do
  trimline "$myline"
done

