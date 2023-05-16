#!/bin/bash

function readconfig
{
  # Read Configuration
  logger -t "$tag" Reading Configuration
  for proc in ${CONFDIR}/*.conf
  do
    # This filename can be web.conf if Bash4, otherwise 1.conf, 2.conf etc
    unset ENABLED START STOP PROCESS MIN MAX STARTDELAY USER STOPPABLE
    index=`basename $proc .conf`
    echo "Reading $index configuration"
    . $proc
    startcmd[$index]=$START
    stopcmd[$index]=$STOP
    process[$index]=$PROCESS
    min[$index]=$MIN
    max[$index]=$MAX
    startdelay[$index]=$STARTDELAY
    user[$index]=$USER
    enabled[$index]=$ENABLED
    idx[$index]=$index
    lastfailure[$index]=0
    stoppable[$index]=${STOPPABLE:-1}
    PID=`pgrep -d ' ' -u ${user[$index]} $PROCESS`
    if [ ! -z "$PID" ]; then
      # Already running
      logger -t "$tag" "${PROCESS} is already running;"\
         " will monitor ${USER}'s PID(s) $PID"
      pid[$index]=$PID
    else
      pid[$index]=-1
      if [ "$ENABLED" ]; then
        startproc $ENABLED $USER $START
      fi
    fi
  done
  logger -t "$tag" "Monitoring ${idx[@]}"

  # Set defaults
  DELAY=10
  FAILWINDOW=180
  debug=9
  . ${CONFDIR}/ha.cfg
}

# If Bash prior to version 4, use declare -a to declare an array
declare -A process
declare -A startcmd
declare -A stopcmd
declare -A min
declare -A max
declare -A pid
declare -A user
declare -A startdelay
declare -A enabled
# Need to keep an array of indices for Bash prior to v4 (no associative arrays)
declare -A idx
declare -A lastfailure
declare -A stoppable

function failurecount
{
  index=$1
  interval=`expr $(date +%s) - ${lastfailure[$index]}`
  lastfailure[$index]=`date +%s`
  if [ "$interval" -lt "$FAILWINDOW" ]; then
    if [ ${stoppable[$index]} -eq 1 ]; then
      logger -t "$tag" "${process[$index]} has failed twice within $interval"\
         " seconds. Disabling."
      enabled[$index]=0
    else
      logger -t "$tag" "${process[$index]} has failed twice within $interval"\
         " seconds but can not be disabled."
    fi
  fi
}

function startproc
{
  if [ "$1" -ne "1" ]; then
    shift 2
    logger -t "$tag" "Not starting \"$@\" as it is disabled."
    return
  fi
  user=$2
  shift 2
  logger -t "$tag" "Starting \"$@\" as \"$user\""
  nohup sudo -u $user $@ >/dev/null 2>&1 &
}

CONFDIR=/etc/ha
tag="hamonitor ($$)"
STOPFILE=/tmp/hastop.$$
READFILE=/tmp/haread.$$
cd `dirname $0`
logger -t "$tag" "Starting HA Monitoring"
readconfig

while :
do
  if [ -f $STOPFILE ]; then
    case `stat -c %u $STOPFILE` in
      0) 
        logger -t "$tag" "$0 FINISHING"
        rm -f $STOPFILE
        exit 0
      ;;
      *)
        logger -t "$tag" "$0 ignoring non-root $STOPFILE"
      ;;
    esac
  fi
  if [ -f $READFILE ]; then
    case `stat -c %u $READFILE` in
      0) readconfig
         rm -f $READFILE
         ;;
      *)
         logger -t "$tag" "$0 ignoring non-root $READFILE"
         ;;
    esac
  fi
  sleep $DELAY
  for index in ${idx[@]}
  do
    if [ ${enabled[$index]} -eq 0 ]; then
      [ "$debug" -gt "3" ] && logger -t "$tag" "Skipping ${process[$index]}"\
           "as it is disabled."
      continue
    fi

    if [ ${pid[$index]} -lt -1 ]; then
      # still waiting for it to start up; skip.
      logger -t "$tag" "Not checking ${process[$index]} yet."
      pid[$index]=`expr ${pid[$index]} + 1`
      continue
    elif [ ${pid[$index]} == -1 ]; then
      pid[$index]=`pgrep -d' ' -u ${user[$index]} ${process[$index]}`
      if [ -z "${pid[$index]}" ]; then
        logger -t "$tag" "${process[$index]} didn't start in the allowed timespan."
        failurecount $index
      fi
      logger -t "$tag" "PID of ${process[$index]} is ${pid[$index]}."
      continue
    fi

    # Check daemon running; start it if not.
    [ "$debug" -gt "2" ] && logger -t "$tag" "Checking ${process[$index]}"
    NewPID=`pgrep -d ' ' -u ${user[$index]} ${process[$index]}`
    if [ -z "$NewPID" ]; then
      # No process found; child is dead.
      logger -t "$tag" "No process for ${process[$index]} found!"
      failurecount $index
      startproc ${enabled[$index]} ${user[$index]} ${startcmd[$index]} 
      if [ ${startdelay[$index]} -eq 0 ]; then
        pid[$index]=`pgrep -d ' ' -u ${user[$index]} ${process[$index]}`
      else
        pid[$index]=`expr 0 - ${startdelay[$index]}`
      fi
      [ "$debug" -gt "4" ] && logger -t "$tag" "Start Delay for"\
          "${process[$index]} is ${startdelay[$index]}."
    elif [ "$NewPID" != "${pid[$index]}" ]; then
        # The PID has changed. Is it just new processes?
        failed=0
        for thispid in ${pid[$index]}
        do
          echo $NewPID | grep -w $thispid > /dev/null
          if [ "$?" -ne "0" ]; then
            # one of our PIDs is missing
            ((failed++))
          fi
        done
        if [ "$failed" -gt "0" ]; then
          failurecount $index
          logger -t "$tag" "PID changed for ${process[$index]}; was "\
             "\"${pid[$index]}\" now \"$NewPID\""
          if [ ${startdelay[$index]} -eq 0 ]; then
            pid[$index]=$NewPID
          else
            pid[$index]=`expr 0 - ${startdelay[$index]}`
          fi
        fi
      else
        # All is well.
        [ "$debug" -gt "3" ] && logger -t "$tag" "${process[$index]} is running"
    fi
  done
done
