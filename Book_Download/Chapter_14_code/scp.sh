#!/bin/bash
user=$1
host=$2
shift 2
files=$@

echo "Testing connection to ${host}..."
ssh -n -o NumberOfPasswordPrompts=0 ${user}@${host}
if [ "$?" -ne "0" ]; then
  echo "FATAL: You do not have passwordless ssh working."
  echo "Try running ssh-add."
  exit 1
fi

echo "Okay. Starting the scp."
scp -B ${files} ${user}@${host}:
if [ "$?" -ne "0" ]; then
  echo "An error occurred."
else
  echo "Successfully copied $files to $host"
fi

echo "I can do ssh as well."
ssh ${user}@${host} ls -ld $files
