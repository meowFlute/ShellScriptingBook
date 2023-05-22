#!/bin/bash
oIFS=$IFS

IFS="
"

hosts=( `cat /etc/hosts` )
for hostline in "${hosts[@]}"
do
  echo line: $hostline
done

# always restore IFS or insanity will follow...
IFS=$oIFS
