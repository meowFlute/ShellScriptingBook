#!/bin/bash
for i in `seq 1 10`
do
  echo "$i squared is `expr $i \* $i`"
done

for i in `seq 1 10`
do
  printf "%2d squared is %3d\n" $i `expr $i \* $i`
done

for i in `seq 1 10`
do
  printf "The square root of %2d is %0.4f\n" $i `echo "scale=10;sqrt($i)"|bc`
done
