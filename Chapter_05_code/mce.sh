#!/bin/sh
if [ -s /var/log/mcelog ]; then
  echo "Machine Check Exceptions found :"
  wc -l /var/log/mcelog
fi
