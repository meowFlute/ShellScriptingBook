#!/bin/bash

echo "Please select a Star Wars movie; enter \"quit\" to quit,"
echo "or type \"help\" for help. Press ENTER to list the options."
echo

# Save the existing value of PS3
oPS3=$PS3
PS3="Choose a Star Wars movie: "
select movie in "A New Hope"    \
    "The Empire Strikes Back"  \
    "Return of the Jedi"       \
    "The Phantom Menace"       \
    "Attack of the Clones"     \
    "Revenge of the Sith"      \
    "The Clone Wars"
do
  if [ "$REPLY" == "quit" ]; then
    # This break must come before other things are run in this loop.
    echo "Okay, quitting. Hope you found it informative."
    break
  fi
  if [ "$REPLY" == "help" ]; then
    echo
    echo "Please select a Star Wars movie; enter \"quit\" to quit,"
    echo "or type \"help\" for help. Press ENTER to list the options."
    echo
    # If we do not continue here, the rest of the loop will be run,
    # and we will get a message "help is not a valid option.",
    # which would not be nice. continue lets us go back to the start.
    continue
  fi

  if [ ! -z "$movie" ]; then
    echo -en "You chose option number $REPLY, which is \"$movie,\" released in "
    case $REPLY in
      1) echo "1977" ;;
      2) echo "1980" ;;
      3) echo "1983" ;;
      4) echo "1999" ;;
      5) echo "2002" ;;
      6) echo "2005" ;;
      7) echo "2008" ;;
    esac
  else
    echo "$REPLY is not a valid option."
  fi
done

# Put PS3 back to what it was originally
PS3=$oPS3
