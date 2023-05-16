#!/bin/bash

function killapp
{
  # if we get here, the application refused to shut down.
  kill -9 `cat /var/run/myapp.pid`
}

case $1 in
  start) 
        echo "Starting myap..."
        /usr/local/bin/myapp &
        echo $! > /var/run/myapp.pid
        ;;
  stop)
        echo "Stopping myapp..."
        timeout -s 15 -k 10 20 /usr/local/bin/stop.myapp
        res=$?
        echo "`date`: myapp returned with exit code $res" >> /var/log/myapp.log
        case "$res" in
          0)   echo "NOTE: myapp stopped by itself." ;;
          124) echo "NOTE: myapp timed out when stopping." 
               killapp ;;
          137) echo "NOTE: myapp was killed when timing out."
               killapp ;;
          *)   echo "Note: myapp exited with return code $res" ;;
        esac
        rm -f /var/run/myapp.pid
        ;;
  *)
        echo "Usage: `basename $0` start | stop"
        exit 2
esac
