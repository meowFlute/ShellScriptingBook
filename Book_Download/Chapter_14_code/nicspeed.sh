#!/bin/bash
# This script only works for the root user.
if [ `id -u` -ne 0 ]; then
  echo "Error: This script has to be run by root."
  exit 2
fi

for nic in `/sbin/ifconfig | grep "Link encap:Ethernet" | \
    grep "^eth" | awk '{ print $1 }'`
do
  echo -en $nic
  ethtool $nic | grep Speed: 
done
