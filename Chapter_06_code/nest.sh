#!/bin/sh
myfruit=""

while [ "$myfruit" != "quit" ]
do
  for fruit in apples bananas pears $myfruit
  do
    echo "I like $fruit"
  done # end of the for loop
  read -p "What is your favorite fruit? " myfruit
done # end of the while loop
echo "Okay, bye!"
