#!/bin/bash

read -p "What is your surname?: " surname
case $surname in
  [a-g]* | [A-G]*) file=1 ;;
  [h-m]* | [H-M]*) file=2 ;;
  [n-s]* | [N-S]*) file=3 ;;
  [t-z]* | [T-Z]*) file=4 ;;
  *) file=0 ;;
esac
if [ "$file" -gt "0" ]; then
  echo "$surname goes in file $file"
else
  echo "I have nowhere to put $surname"
fi
