#!/bin/bash
host=${1:-declan}

while :
do
  ping -c3 -w 4 $host > /dev/null 2>&1
  if [ "$?" -eq "0" ]; then
    echo "`date`: $host is up"
  else
    echo "`date`: $host is down"
  fi
  sleep 30
done
