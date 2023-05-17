#!/bin/bash
GAP=10                      # how long to wait
LOGFILE=$1                  # file to log to

# Get the current length of the file.
len=`wc -l $LOGFILE | awk '{ print $1 }'`
echo "Current size is $len lines"

while :
do
  if [ -N $LOGFILE ]; then
    echo "`date`: New entries in $LOGFILE:"
    newlen=`wc -l $LOGFILE | awk '{ print $1 }'`
    newlines=`expr $newlen - $len`
    tail -$newlines $LOGFILE
    len=$newlen
  fi
  sleep $GAP
done
