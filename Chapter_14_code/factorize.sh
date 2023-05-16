#!/bin/bash

function factorize
{
  # echo "Parsing $@"
  if [ "$#" -gt "1" ];
  then
    sum=`expr $1 \* $2`
    echo "$1 x $2 = $sum"
    shift 2
    factorize $sum $@ 
  fi
}

# GNU says: 72: 2 2 2 3 3
# UNIX says: 
#72
#  2
#  2
#  2
#  3
#  3
# So test for GNU vs non-GNU

factor --version | grep GNU > /dev/null 2>&1
if [ "$?" -eq "0" ]; then
  factorize `factor $1 | cut -d: -f2-`
else
  factorize `factor $1 | grep -v "^${1}" `
fi

