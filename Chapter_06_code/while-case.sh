#!/bin/bash

quit=0
while read command data
do
  case $command in
    echo)
        echo "Found an echo command: $data"
        ;;
    upper)
        echo -en "Found an upper command: "
        echo $data | tr '[:lower:]' '[:upper:]'
        ;;
    lower)
        echo -en "Found a lower command: "
        echo $data | tr '[:upper:]' '[:lower:]'
        ;;
    quit)
        echo "Quitting as requested."
        quit=1
        break
        ;;
    *)
        echo "Read $command which is not valid input."
        echo "Valid commands are echo, upper, lower, or quit."
        ;;
  esac
done

if [ $quit -eq 1 ]; then
  echo "Broke out of the loop as directed."
else
  echo "Got to the end of the input without being told to quit."
fi
