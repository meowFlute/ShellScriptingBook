#!/bin/bash

kb=`head -1 /proc/meminfo | awk '{ print $2 }'`
mb=`echo "scale=2; $kb / 1024"| bc`
gb=`echo "scale=2; $mb / 1024"| bc`
echo "Server has $gb Gb ($kb Kb)"

cd /sys/devices/system/node
grep MemTotal node*/meminfo | while read name node memtotal kb kB
do
  mb=`echo "scale=2; $kb / 1024"| bc`
  gb=`echo "scale=2; $mb / 1024"| bc`
  echo "Node $node has $gb Gb. "\
  "`grep -w 1 /sys/devices/system/node/node${node}/cpu[0-9]*/online\
  |wc -l` CPUs online"
done
