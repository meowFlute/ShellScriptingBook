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
#       Things you'll notice:
#           - numerical tests use things like -eq, -lt, -ne instead of =, <, != to differentiate them from string tests
#           - you combine tests with && and ||
#               - you can also use the fact that these are only attempted after testing the preceeding test
#                   - e.g. without an if statement you can just do the following:
#                       - [ -r /etc/hosts ] && echo "/etc/hosts is readable" will only echo on success
#                       - [ -r /etc/hosts ] || echo "/etc/hosts is not readable" will only echo on failure
#                   - the book says this is good to know to read other scripts but pointless because it isn't faster

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

# case flow
#   the following example demonstrates case syntax
#   some notes:
#       - the *) would work like a catch-all default
#       - your cases can be multiplexed with single | and & operators, and include character classes and such (globbing rules?)
#       - ending with ;; means no other cases will be executed, but there are other options
#           - ;;& means all subsequent cases will still be evaluated
#           - ;& means the following case will be treated as having matched even if it doesn't
os_type_str="$OSTYPE"   # I needed the quotes around the variable name to treat it as a string 
echo
echo -e "${PURPLE}This example looks at some cases for \$OSTYPE and demonstrates the possible ending usage${NO_COLOR}"
echo "\$OSTYPE=$OSTYPE"
shopt -s nocaseglob
case $os_type_str in    # I needed the $ in the variable name here
    *linux* )   echo "you're in linux"              ;;&
    *gnu*)      echo "what a king, gnu master"      ;;
    *cygwin*)   echo "you're in cygwin"             ;;
    *darwin*)   echo "you're on a mac"              ;&
    *)          echo "this is trash"                ;;
esac
shopt -u nocaseglob
