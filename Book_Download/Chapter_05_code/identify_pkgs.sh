#!/bin/bash

for pkg in pkgs/*
do
  pkgname=`basename $pkg`
  echo $pkgname
  if [[ $pkgname =~ (.+)_(.*)_(.*)\.(deb) ]]; then
    echo "Package ${BASH_REMATCH[1]} Version ${BASH_REMATCH[2]} is a"
    echo "   Debian package for the ${BASH_REMATCH[3]} architecture."
    echo
  elif [[ $pkgname =~ (.+)-(.+)\.(.*)\.rpm ]]; then
    echo "Package ${BASH_REMATCH[1]} Version ${BASH_REMATCH[2]} is an"
    echo "   RPM for the ${BASH_REMATCH[3]} architecture."
    echo
  else
    echo "File \"$pkgname\" does not appear to match the"
    echo "standard .deb or .rpm naming conventions."
  fi
done
