#!/bin/bash
master=$1
fifo=/tmp/fifo.$master
log=/tmp/log.$master

while :
do
  read cmd args < $fifo
  if [ ! -z "$cmd" ]; then
    if [ "$cmd" == "quit" ]; then
      echo "Very good, master." | tee -a $log
      exit 0
    fi
    echo "`date`: Executing \"${cmd}\" for the master." | tee -a $log
    if [ ! -z "$args" ]; then
      for arg in $args
      do
        echo -en "$arg " | tee -a $log
        sleep 1
      done
      echo | tee -a $log
    fi
  fi
  sleep 10
done
