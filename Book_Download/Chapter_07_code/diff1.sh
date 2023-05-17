#!/bin/bash

diff $1 $2 | while read diffline
do  
  if [ "${diffline:0:2}" == "< " ]; then
    echo "Remove line: ${diffline:2}"
  fi
  if [ "${diffline:0:2}" == "> " ]; then
    echo "Add line: ${diffline:2}"
  fi
done
