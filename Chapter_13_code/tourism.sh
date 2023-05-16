#!/bin/bash
cd places
place=$(shuf -e -n1 *)
days=${1:-2}

echo -en "Let's go to $place and check out "
count=1
shuf -n$days "$place" | while read trip
do
  let count=$count+1
  echo -en $trip
  if [ "$count" -le "`expr $days - 1`" ]; then
    echo -en ", "
  elif [ "$count" -le "$days" ]; then
    echo -en " and "
  else
    echo " "
  fi
done
