#!/bin/bash

function help_output()
{
    echo "Usage: ./ch03_variables_examples.sh [ OPTION ]"
    echo
    echo "Options:"
    echo "    -s, --skip  skips the user input sections"
    echo "    -h, --help  displays this information"
}

# initialize flags to defaults for optional arguments
sflag=no
hflag=no

# options may be followed by one colon to indicate they have a required argument
if ! options=$(getopt -o sh -l skip,help -- "$@")
then
    # something went wrong, getopt will put out an error message for us
    help_output
    exit 1
fi

set -- $options

while [ $# -gt 0 ]
do
    case $1 in # if we did have an argument passing more than just a flag we'd need two skips
	-s|--skip) sflag=yes							    ;;
	-h|--help) help_output; exit 1						    ;;
	(--) shift; break							    ;;
	(-*) echo "$0: error - unrecognized option $1" 1>&2; help_output; exit 1    ;;
	(*) break								    ;;
    esac
    shift # this throws away the argument we just processed
done

#echo "sflag=$sflag"
#echo "hflag=$hflag"

# skip these user input sections by passing a first argument of skip when running
if [ "$sflag" != "yes" ]
then
    # the -n character makes echo not do a newline
    echo -n "Enter some kind of input: "
    # the read command uses the user input to set the variable
    read user_input0
    # we can access that variable using a $
    echo "The input you entered was: $user_input0"

    # read can be used to bring in multiple variables
    # The last variable will take up all unread text
    echo
    echo -n "Now please enter two or more words: "
    read user_input1 user_input2
    echo "The first word you entered was: $user_input1, and the second group included: $user_input2"
else
    echo "SKIPPING USER INPUT SECTIONS"
fi

# Just set will list all the environment variables
# this means you can grep that list to see values you set previously
echo
echo "Relevant variables:"
set | grep user_input

# read will also read a single line in
echo
echo "The first line of /etc/fstab is:"
read line < /etc/fstab
echo $line

# the return value of read is such that you can use it in a while loop because it returns nonzero for EOL
# it will only quit on its own by returning 0 when it hits EOF
# kinda weird syntax, I would have tried while read line < /etc/fstab but that does some kind of infinite loop 
#     with undesired output that just is the first line over and over and over.
echo
echo "The whole file of /etc/fstab is:"
while read line
do
    echo $line
done < /etc/fstab

# You can set variables to the output of a given command. For example, to set day to Monday on Mondays,
# "Tuesday" on Tuesdays, and so on you can do either of the following. I'm still unaware of the difference
# between backticks `` and $() expansions
day_backtick=`date +%A`
day_dollar=$(date +%A)
echo
echo "The backtick expansion of \`date +%A\` is: $day_backtick"
echo "The dollar expansion of \$(date +%A) is: $day_dollar"
echo "You can do both without variables as well: `date +%A` $(date +%A)"


