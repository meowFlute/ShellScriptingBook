#!/bin/bash
host=${1:-declan}

while grep -qw $host /tmp/hosts-to-ping.txt
do
  ping -c3 -w 4 $host > /dev/null 2>&1
  if [ "$?" -eq "0" ]; then
    echo "`date`: $host is up"
  else
    echo "`date`: $host is down"
  fi
  sleep 30
done

echo "Stopped testing $host as it has been removed from /tmp/hosts-to-ping.txt"
