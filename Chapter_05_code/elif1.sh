#!/bin/bash
OS=`uname -s`

if [ "$OS" = "FreeBSD" ]; then
  echo "This Is FreeBSD"
else
  if [ "$OS" = "CYGWIN_NT-5.1" ]; then
    echo "This is Cygwin"
  else
    if [ "$OS" = "SunOS" ]; then
      echo "This is Solaris"
    else
      if [ "$OS" = "Darwin" ]; then
        echo "This is Mac OSX"
      else
        if [ "$OS" = "AIX" ]; then
          echo "This is AIX"
        else
          if [ "$OS" = "Minix" ]; then
            echo "This is Minix"
          else
            if [ "$OS" = "Linux" ]; then
              echo "This is Linux"
            else
              echo "Failed to identify this OS"
            fi
          fi
        fi
      fi
    fi
  fi
fi
