#!/bin/bash

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
echo
echo "The whole file of /etc/fstab is:"
while read line
do
    echo $line
done < /etc/fstab
