#!/bin/bash

TFTPBOOT=/tftpboot/linux-install/pxelinux.cfg
NFS=/kickstart
CLIENT=`getent hosts $1 | awk '{ print $2 }'`
if [ -z "$CLIENT" ]; then
    echo "A failure occurred in looking up \"$1\""
    exit 2
fi
SERVER=`hostname`
OSNAME=RHEL60

function calc_client_details
{
  CLIENT_IP=`getent hosts $CLIENT | awk '{ print $1 }'`
  if [ -z "$CLIENT_IP" ] || [ -z "$CLIENT" ]; then
    echo "A failure occurred in looking up \"$CLIENT\""
    exit 2
  fi
  # 192.168.1.42 is C0 A8 01 2A
  # This does not work :-(
  # CLIENT_HEXADDR=`echo "obase=16;$A" | tr '.' '\n' | bc | tr -d '\n'`
  CLIENT_HEXADDR=$(printf "%02X%02X%02X%02X" `echo $CLIENT_IP | tr '.' ' '`)
  if [ "`echo -n $CLIENT_HEXADDR | wc -c`" -ne "8" ]; then
    echo "An error occurred processing the Hex IP Address for \"$CLIENT\""
    echo "IPv4 Address detected: $CLIENT_IP"
    echo "Hex IP Address calculated: $CLIENT_HEXADDR"
    exit 1
  fi
  echo "Client details: $CLIENT is at IP address $CLIENT_IP ($CLIENT_HEXADDR)"
}

function create_tftp_record
{
  cat - > ${TFTPBOOT}/${CLIENT_HEXADDR} <<-EOF
	default boot
	timeout 600
	prompt 1
	display messages/${CLIENT}.txt
	F1 messages/${CLIENT}.txt
	F2 messages/${CLIENT}-F2.txt

	label boot
	  localboot 0
	label install
	  kernel ${OSNAME}/vmlinuz
	  append initrd=${OSNAME}/initrd.img ks=nfs:${SERVER}:${NFS}/${CLIENT}.cfg
	EOF
  ls -ld ${TFTPBOOT}/${CLIENT_HEXADDR}
}

function create_kickstart
{
  mkdir -p ${NFS}
  if [ "$?" -ne "0" ]; then
    echo "Error creating ${NFS}"
    exit 1
  fi
  cat - > ${NFS}/${CLIENT}.cfg <<-EOF
	# Kickstart file for $CLIENT to boot from $SERVER
	text install
	# You would probably want to put more details here
	# but this is a shell scripting recipe not a kickstart recipe
	%post
	echo This is the postinstall routine
	printf "10.2.2.2\ttimeserver" >> /etc/hosts"
	/net/$SERVER/$NFS/${CLIENT}.postinstall
	EOF
  ls -ld ${NFS}/${CLIENT}.cfg
}

function create_msgs
{
  CLIENTFILE=${TFTPBOOT}/messages/client.txt
  CLIENTF2=${TFTPBOOT}/messages/client-f2.txt
  MYFILE=${TFTPBOOT}/messages/${CLIENT}.txt
  MYF2=${TFTPBOOT}/messages/${CLIENT}-f2.txt
  if [ ! -r "$CLIENTFILE" ]; then
    echo "Error reading $CLIENTFILE"
    exit 1
  fi

  sed s/CLIENT_NAME_HERE/$CLIENT/g $CLIENTFILE | \
        sed s/SERVER_NAME_HERE/$SERVER/g | \
	sed s/OSNAME/$OSNAME/g > ${MYFILE}
  sed s/CLIENT_NAME_HERE/$CLIENT/g $CLIENTF2 | \
        sed s/SERVER_NAME_HERE/$SERVER/g > ${MYF2}
  ls -ld ${MYFILE}
  ls -ld ${MYF2}
}

calc_client_details

create_msgs
create_kickstart
create_tftp_record
