#!/bin/bash

function stopdial
{
 if [ ! -z "$DIALPID" ]; then 
   kill -9 $DIALPID 
   echo -en " "
   unset DIALPID
   echo
 fi
}

function dial
{
  dial=('/' '-' '\' '|' '/' '-' '\' '|' )
  echo -en " "
  d=0
  while :
  do
    echo -en "${dial[$d]}"
    d=`expr $d + 1`
    d=`expr $d % 8` # size of dial[] array
    sleep 1
  done
  echo -en " "
}

# on any signal stop the dial subprocess
trap stopdial `seq 1 63`

echo Starting
echo "`date`: Doing something long and complicated..."

echo -en "Here is a dial to keep you amused: "
dial &
DIALPID=$!
sleep 10
stopdial

echo "`date`: Finished the complicated bit. That was hard!"
echo Done
