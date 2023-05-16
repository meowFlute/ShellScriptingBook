#!/bin/bash
DATEFORMAT="%m/%d/%Y"

TODAY=`date +${DATEFORMAT}`
echo "Today is $TODAY"

# Get the three dates
LONGTERM=`date -d "30 days"  "+${DATEFORMAT}"`
ARCHIVAL=`date -d "3 months" "+${DATEFORMAT}"`
DELETION=`date -d "7 years"  "+${DATEFORMAT}"`

echo "Files will be moved to long term storage in 30 days (midnight at $LONGTERM)."
echo "Files will be archived at midnight on $ARCHIVAL."
echo "They will be deleted at midnight on $DELETION."

at -f /usr/local/bin/longterm_records "$1" midnight $LONGTERM
at -f /usr/local/bin/archive_records  "$1" midnight $ARCHIVAL
at -f /usr/local/bin/delete_records   "$1" midnight $DELETION
