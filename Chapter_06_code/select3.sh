#!/bin/bash

# Save the existing value of PS3
oPS3=$PS3
PS3="Please choose a task (ENTER to list options): "
select task in Quit "View hosts" "Edit hosts" "Search hosts"\
      "Nameservice Lookup" "DNS Lookup"
do
  if [ ! -z "$task" ]; then
    case $REPLY in
      1) echo "Goodbye."
         break
         ;;
      2) cat /etc/hosts
         ;;
      3) ${EDITOR:-vi} /etc/hosts
         ;;
      4) read -p "Enter the search term: " search
         grep -w $search /etc/hosts || echo "\"$search\" Not Found."
         ;;
      5) read -p "Enter the host name: " search
         getent hosts $search || echo "\"$search\" Not Found."
         ;;
      6) read -p "Enter the host name: " search
         nslookup $search || echo "\"$search\" Not Found."
         ;;
    esac
  else
    echo "$REPLY is not a valid option."
  fi
done

# Put PS3 back to what it was originally
PS3=$oPS3
