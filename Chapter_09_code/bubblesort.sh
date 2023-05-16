#!/bin/bash


function bubblesort()
{ 
  n=${#data[@]}
  for i in `seq 0 $n`
  do
    for (( j=n; j > i; j-=1 ))
    do
      if [[ ${data[j-1]} > ${data[j]} ]]
      then
        temp=${data[j]}
        data[j]=${data[j-1]}
        data[j-1]=$temp
      fi
    done
  done
}


data=( roger oscar charlie kilo indigo tango )

echo "Initial state:"
for i in ${data[@]}
do
  echo "$i"
done

bubblesort 

echo
echo "Final state:"
for i in ${data[@]}
do
  echo "$i"
done

