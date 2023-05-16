#!/bin/bash
for number in 1 2 3 4 5 6
do
  echo "In the number loop - $number"
  read -n1 -p "Press b to break out of this loop: " x
  if [ "$x" == "b" ]; then
    break
  fi
  echo
  for letter in a b c d e f
  do
    echo
    echo "Now in the letter loop... $number $letter"
    read -n1 -p "Press 1 to break out of this loop, 2 to break out totally: " x
    if [ "$x" == "1" ]; then
      break
    else
      if [ "$x" == "2" ]; then
        break 2
      fi
    fi
  done
  echo
done
echo
echo "That's all, folks"

