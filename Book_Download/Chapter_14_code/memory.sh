#!/bin/bash

LOGFILE=/var/tmp/memory.txt
while :
do
  RAM=`grep MemFree /proc/meminfo | awk '{ print $2 }'`
  echo "At `date +'%H:%M on %d %b %Y'` there is $RAM Kb free on `hostname -s`" | tee -a $LOGFILE
  sleep 60
done
