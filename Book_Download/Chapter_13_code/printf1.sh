#!/bin/bash

printf "%-10s %-30s %-10s\n" "Username" "Name" "Shell"
cut -d: -f1,5,7 /etc/passwd | while IFS=: read uname name shell
do
  printf "%-10s %-30s %-10s\n" "$uname" "$name" "$shell"
done
