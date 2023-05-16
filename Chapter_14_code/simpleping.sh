#!/bin/bash
LOG=ping.log
PREFIX=192.168.1
i=1

while [ "$i" -lt "8" ]
do
  echo "Pinging ${PREFIX}.$i"
  ping ${PREFIX}.$i  > /tmp/ping.$i 2>&1 &
  sleep 2
  kill -9 $!
  grep "^64 bytes from" /tmp/ping.$i
  if [ "$?" -eq "0" ]; then
    echo "${PREFIX}.$i is alive" | tee -a $LOG
  else
    echo "${PREFIX}.$i is dead" | tee -a $LOG
  fi
  rm -f /tmp/ping.$i
  i=`expr $i + 1`
done
