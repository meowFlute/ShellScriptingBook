#!/bin/bash

if [ ! -f /sys/devices/system/node/node0/cpu0/online ]; then
  echo "node0/cpu0 is always Online."
fi

function showcpus()
{
  cpu=${1:-'*'}
  for node in `ls -d /sys/devices/system/node/node*/cpu${cpu}| cut -d"/" -f6|sort -u`
  do
    grep . /sys/devices/system/node/${node}/cpu*/online /dev/null \
           | cut -d"/" -f6- | sed s/"\/online"/""/g | sed s/":1$"/" is Online"/g \
           | sed s/":0$"/" is Offline"/g
  done
}

function online()
{
  if [ ! -f /sys/devices/system/node/node*/cpu${1}/online ]; then
    echo "CPU$i does not have online/offline functionality"
  else
    grep -q 1 /sys/devices/system/node/node*/cpu${1}/online 
    if [ "$?" -eq "0" ]; then
      echo "CPU$cpu is already Online"
    else
      echo -en "`showcpus $cpu` - "
      echo -en "Onlining CPU$cpu ... "
      echo 1 > /sys/devices/system/node/node*/cpu${1}/online 2> /dev/null 
      if [ "$?" -eq "0" ]; then
        echo "OK"
      else
        echo "Failed to online CPU$cpu"
      fi
    fi
  fi
}

function offline()
{
  if [ ! -f /sys/devices/system/node/node*/cpu${1}/online ]; then
    echo "CPU$i does not have online/offline functionality"
  else
    grep -q 0 /sys/devices/system/node/node*/cpu${1}/online 
    if [ "$?" -eq "0" ]; then
      echo "CPU$cpu is already Offline"
    else
      echo -en "`showcpus $cpu` - "
      echo -en "Offlining CPU$cpu ... "
      echo 0 > /sys/devices/system/node/node*/cpu${1}/online 2> /dev/null 
      if [ "$?" -eq "0" ]; then
        echo "OK"
      else
        echo "Failed to offline CPU$cpu"
      fi
    fi
  fi
}

case $1 in
  show) showcpus $2
	;;
  on)   
	shift            # Lose the keyword
	for cpu in $* 
        do
          online $cpu
        done
	;;
  off)  
	shift            # Lose the keyword
	for cpu in $*
        do
          offline $cpu
        done
	;;
  *) echo "Usage: "
     echo "  `basename $0` show [ cpu# ] - shows all CPUs shared by that node"
     echo "  `basename $0` on cpu# ( cpu# cpu# cpu# ... )"
     echo "  `basename $0` off cpu# ( cpu# cpu# cpu# ... )"
     ;;
esac

