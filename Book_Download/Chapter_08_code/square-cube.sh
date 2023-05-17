#!/bin/bash

squarecube()
{
  echo "$2 * $2" | bc > $1
  echo "$2 * $2 * $2" | bc >> $1
}

output=`mktemp`
for i in 1 2 3 4 5
do
  squarecube $output $i
  echo "The square of $i is `head -1 $output`"
  echo "The cube of $i is `tail -1 $output`"
done
rm -f $output
