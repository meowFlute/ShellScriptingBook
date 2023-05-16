#!/bin/bash

PREFIX=192.168.1
OCTET=1
while [ "$OCTET" -lt "255" ]; do
  echo -en "Pinging ${PREFIX}.${OCTET}..."
  ping -c1 -w1 ${PREFIX}.${OCTET} >/dev/null 2>&1
  if [ "$?" -eq "0" ]; then
    echo " OK"
  else
    echo "Failed"
  fi
  let OCTET=$OCTET+1
done

