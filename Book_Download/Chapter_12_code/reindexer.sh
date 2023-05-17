#!/bin/bash
LASTRUN=/var/run/web.lastrun
WEBROOT=/var/www
# be verbose if asked.
START_TIME=`date`

function reindex
{
  # Do whatever magic is required to add this new/updated 
  # file to the database.
  add_to_database "$@"
}


if [ ! -f "$LASTRUN" ]; then
  echo "Error: $LASTRUN not found. Will reindex everything."
  # index from the epoch...
  touch -d "1 Jan 1970" $LASTRUN
  if [ "$?" -ne "0" ]; then
    echo "Error: Cannot update $LASTRUN"
    exit 1
  fi
fi

cd $WEBROOT
find . -type f -newer $LASTRUN -print | while read filename
do
  reindex "$filename"
done
echo "Run complete at `date`."
echo "Subsequent runs will pick up only files updated since this reindexing"
echo "which was started at $START_TIME"
touch -d "$START_TIME" $LASTRUN
if [ "$?" -ne "0" ]; then
  echo "Error: Cannot update $LASTRUN"
  exit 1
fi
ls -ld $LASTRUN
