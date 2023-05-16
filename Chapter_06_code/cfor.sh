#!/bin/bash

for ((i=1,j=100; i<=10; i++,j-=2))
do
  printf "i=%03d j=%03d\n" $i $j
done
