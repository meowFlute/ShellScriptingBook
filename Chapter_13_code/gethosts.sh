#!/bin/bash
HOSTS=hosts
ETHERS=ethers
IPS=ips

set -o pipefail
for host in `cat $HOSTS`
do
  echo -en "${host}..."
  getent hosts $host | cut -d" " -f1 >> $IPS || echo "missing" >> $IPS
  grep -w "${host}" mac | cut -d" " -f1 >> $ETHERS \
    || echo "missing" >> $ETHERS
done
echo
paste $HOSTS $IPS $ETHERS
