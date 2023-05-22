#!/bin/bash
# Employee Data
Dave_Fullname="Dave Smith"
Dave_Country="USA"
Dave_Email=dave@example.com

Jim_Fullname="Jim Jones"
Jim_Country="Germany"
Jim_Email=jim.j@example.com

Bob_Fullname="Bob Anderson"
Bob_Country="Australia"
Bob_Email=banderson@example.com

echo "Select an Employee:"
select Employee in Dave Jim Bob
do
  echo "What do you want to know about ${Employee}?"
  select Data in Fullname Country Email
  do
    echo $Employee			# Jim
    echo $Data			# Email
    empdata=${Employee}_${Data} 	# Jim_Email
    echo "${Employee}'s ${Data} is ${!empdata}"	# jim.j@example.com
    break
  done 
  break
done
