#!/bin/bash

HOSTS=${HOSTS:-$1}

while read -p "Host to check: " hostname
do
  if [ -z "$hostname" ]; then
    echo "Quitting due to blank input"
    break
  fi
  ping -c1 -w1 $hostname > /dev/null 2>&1
  if [ "$?" -eq "0" ]; then
    echo "Contact made with $hostname"
  else
    echo "Failed to make contact with $hostname"
  fi
done < $HOSTS
