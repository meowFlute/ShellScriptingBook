#!/bin/sh
DEV1=${1:-sday}
DEV2=${2:-sdu}
DEV3=${2:-sdcc}
DEV4=${2:-sddg}

EXPECTED=350

cd /var/tmp
rm -f dd.pid

for DEV in $DEV1 $DEV2 $DEV3 $DEV4
do
  dd if=/dev/$DEV of=/dev/null bs=8192 count=1000000 2>&1|grep -w copied \
     >> dd.$DEV &
  echo $! >> dd.pid
done

sleep $EXPECTED
CHILDREN=2
while [ "$CHILDREN" -gt "0" ]
do
  echo "`date`: I have $CHILDREN children"
  sleep 5
  CHILDREN=`ps hfp $(cat dd.pid) | wc -l`
done

MAILOUT=0
for SECONDS in `awk '{ print $6 }' dd.$DEV1 dd.$DEV2 dd.$DEV3 dd.$DEV4 |\
     cut -d"." -f1`
do
  if [ "$SECONDS" -gt "$EXPECTED" ]; then
    MAILOUT=1
  fi
done

if [ "$MAILOUT" == "1" ]; then
  for DEV in $DEV1 $DEV2 $DEV3 $DEV4
  do
    msg=`cat dd.$DEV`
    logger -t storagespeed "Path Comparison: $DEV :$msg"
  done

  echo "It should take no more than $EXPECTED seconds to read 8Gb from a device."\
     "It took:\n`grep . dd.$DEV1 dd.$DEV2 dd.$DEV3 dd.$DEV4`" |\
     mailx -s "Slow I/O on `uname -n`" storage@example.com
fi
