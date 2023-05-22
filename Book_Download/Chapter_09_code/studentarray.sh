#!/bin/bash

students=( Dave Jennifer Michael    # year 1
  Alistair Lucy Richard Elizabeth   # year 2
  Albert Roger Dennis James Roy     # year 3
  Rory Jim Andi Elaine Clive        # year 4
  )

for name in ${students[@]}
do
  echo -en "$name "
done
echo
