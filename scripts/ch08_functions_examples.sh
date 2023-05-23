#!/bin/bash

# Colors to differentiate my notes from program execution
PURPLE='\033[1;34m'
NO_COLOR='\033[0m'
echo_purple()
{
    # Usage 
    #	echo_purple "message"		for normal echo
    #	echo_purple "message" "\n"	for a skip prior to separate lines
    echo -e "${2:-""}${PURPLE}${1}${NO_COLOR}"
}

# -- Function Syntax
#	you can define functions in three ways:
#	    1) function_name()		    # most portable, accepted by the Bourne shell
#	    2) function function_name	    # maybe a little more clear
#	    3) function function_name()	    # Bash only, probably don't want to use it, but you can

# -- Function Output
#	Return Codes:
#	    One unsigned byte for return values (0-255). Use this by something like "return 0". 
#	    A case statement might be good for processing return codes
#	    These codes are returned via #?
#	Returning a String:
#	    return_string=`function_name [args]` will return all echo output to return_string
#	    tmp_file=`mktemp` takes advantage of this to generate a random tmp filename, because
#		mktemp will echo the randomly generated filename, and in this configuration it is
#		silently applied to the tmp_file variable
#	Writing to a file:
#	    A function can write to a file -- think about doing a tmp_output=`mktemp` as described above!
#		This allows for complex return behavior (because shell doesn't support anything not described above)
echo_purple "A cool example of using the backtick echo format to generate a random tmp filename for complex return behavior" "\n"

squarecube()
{
  echo "$2 * $2" | bc > $1
  echo "$2 * $2 * $2" | bc >> $1
}

output=`mktemp`
for i in 1 2 3
do
  squarecube $output $i
  echo "The square of $i is `head -1 $output`"
  echo "The cube of $i is `tail -1 $output`"
done
rm -f $output

