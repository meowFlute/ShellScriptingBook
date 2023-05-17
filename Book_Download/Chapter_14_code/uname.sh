#!/bin/sh
case `uname -m` in
  amd64|x86_64) bits=64	;;
  i386|i586|i686) bits=32 ;;
  *) bits=unknown	;;
esac
echo "You have a ${bits}-bit machine."
