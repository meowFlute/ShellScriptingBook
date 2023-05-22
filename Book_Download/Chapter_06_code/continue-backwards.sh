#!/bin/bash
i=1
while [ "$i" -lt "5" ]; do
  echo "i is $i"
  read -p "Press r to repeat, any other key to continue: " x
  if [ "$x" == "r" ]; then
    echo "Going again..."
    continue
  fi
  let i=$i+1
done
