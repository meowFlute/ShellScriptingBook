#!/bin/bash

function stopdial
{
 if [ ! -z "$DIALPID" ]; then 
   kill -9 $DIALPID 
   unset DIALPID
   echo
 fi
}

function dial
{
  echo -en " "
  while :
  do
    echo -en "`date`"
    sleep 1
  done
  echo
}

# on any signal stop the dial subprocess
trap stopdial `seq 1 63`

echo Starting
echo "`date`: Doing something long and complicated..."

dial &
DIALPID=$!
sleep 10
stopdial

echo "`date`: Finished the complicated bit. That was hard!"
echo Done
