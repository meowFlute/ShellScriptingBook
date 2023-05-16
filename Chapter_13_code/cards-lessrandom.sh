#!/bin/bash

suits=( diamonds clubs hearts spades )
values=( one two three four five 
         six seven eight nine ten
         jack queen king )

function randomcard
{
  echo "the `shuf --random-source=/tmp/random -n1 -e ${values[@]}` of"\
       "`shuf --random-source=/tmp/random -n1 -e "${suits[@]}"`"
}

echo "You rejected `randomcard`"
echo "You rejected `randomcard`"
echo "You rejected `randomcard`"
YOURCARD=`randomcard`
echo "You picked $YOURCARD."
echo "I remember $YOURCARD so it is no longer random."
echo "It will always be $YOURCARD."
