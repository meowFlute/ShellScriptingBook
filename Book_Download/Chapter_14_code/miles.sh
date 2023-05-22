#!/bin/bash
# 1m ~= 1.609 km

for miles in `seq 1 0.25 5`
do
  km=`echo "scale=2 ; $miles * 1.609" | bc`
  printf "%0.2f miles is %0.2f kilometres\n" $miles $km
  #echo "$miles miles is $km km"
done
