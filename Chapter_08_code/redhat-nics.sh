#!/bin/sh

getipaddr()
{
  cd /etc/sysconfig/network-scripts || return 1
  if [ -f ifcfg-$1 ]; then
    unset IPADDR
    . ifcfg-$1
    if [ -z "$IPADDR" ]; then
      return 2
    else
      echo $IPADDR
    fi
  else
    return 3
  fi
  # Not strictly needed
  return 0
}

for thisnic in eth0 eth1 eth2
do
  thisip=`getipaddr $thisnic`
  case $? in
    0) echo "The IP Address configured for $thisnic is $thisip" ;;
    1) echo "This does not seem to be a RedHat system" ;;
    2) echo "No IP Address defined for $thisnic" ;;
    3) echo "No configuration file found for $thisnic" ;;
  esac
done
