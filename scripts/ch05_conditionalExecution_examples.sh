#!/bin/bash

# Colors to differentiate my notes from program execution
PURPLE='\033[1;34m'
NO_COLOR='\033[0m'
# use the following for a quick copy-paste reference
# echo -e "${PURPLE}${NO_COLOR}"

# test and [
#   This kind of blew my mind, but the reason that if requires a space before and after the [ is because [ is a program!!!?!
#   Observe:
echo -e "${PURPLE}Check out what happens when we look for [${NO_COLOR}\nwhich ["
which [ # ]
#       it outputs "/user/bin/[" !!!
#       WHAAAAT!!!??
#   So the explains all the weird testing syntax rules about being really picky with whitespace
#   [ is a command that takes an expression and ] as arguments, and if you forget the ] it gets mad
#   it needs whitespace to be recognized as such
# DOCUMENTATION ON TEST TYPES AND OPTIONS
#   look in "man 1 test"

# if, else, elif, fi
#   The above revelation explains the required syntax for something like this
echo
echo -e "${PURPLE}Let's look at some test [ examples using if statements${NO_COLOR}"
if [ -f ~/.bashrc ]
then
    echo "~/.bashrc on this system is a file!"
else
    echo "~/.bashrc is not a file!"
    if [ ! -e ~/.bashrc ]
    then
        echo "in fact, it doesn't exist!"
    fi
fi

if [ -r ~/.bashrc ]
then
    echo "it can be read"
fi

if [ -w ~/.bashrc ]
then
    echo "it can be written"
fi

if [ -x ~/.bashrc ]
then
    echo "it can be executed...?"
fi

if [ -h ~/.bashrc ]
then
    echo "it is a symlink"
fi

