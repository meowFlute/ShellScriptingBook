#!/bin/bash

for deb in pkgs/*
do
  pkgname=`basename $deb`
  echo $pkgname
  if [[ $pkgname =~ (.+)_(.*)_(.*)\.deb ]]; then
    echo "Package ${BASH_REMATCH[1]} Version ${BASH_REMATCH[2]}"\
         "is for the \"${BASH_REMATCH[3]}\" architecture."
    echo
  else
    echo "File \"$pkgname\" does not appear to match the "
    echo "standard .deb naming convention."
    echo
  fi
done
