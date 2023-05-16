#!/bin/bash
ROOTDIR=${1:-/opt/myapp}
OWNER=${2:-myapp}
GROUP=${3:-myapp}

# Create bin and opt directories. Parents will be 755; if run
# as root, their ownership will be root:root. (any suid/sgid will be preserved)
install -v -m 755 -o $OWNER -g $GROUP -d $ROOTDIR/bin $ROOTDIR/etc
if [ "$?" -ne "0" ]; then
  echo "Install: Failed to create directories."
  exit 1
fi

# install the binary itself
install -b -v -m 750 -o $OWNER -g $GROUP -s myapp $ROOTDIR/bin
if [ "$?" -ne "0" ]; then
  echo "Install: Failed to install the binary"
  exit 2
fi

# Install the configuration file, only read-writeable by the owner.
install -b -v -m 600 -o $OWNER -g $GROUP myapp.conf $ROOTDIR/etc
if [ "$?" -ne "0" ]; then
  echo "Install: Failed to install the config file"
  exit 3
fi

echo "Install: Succeeded."
