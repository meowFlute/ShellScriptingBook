#!/bin/bash

while read ip name aliases
do
  echo $ip | grep "[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*" > /dev/null
  if [ "$?" -eq "0" ]; then
    # Okay, looks like an IPv4 address
    echo "$name is at $ip"
    if [ ! -z "$aliases" ]; then 
      echo "  ... $name has aliases: $aliases"
    fi
  fi
done < /etc/hosts
