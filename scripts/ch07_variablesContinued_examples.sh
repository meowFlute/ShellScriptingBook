#!/bin/bash

# Colors to differentiate my notes from program execution
PURPLE='\033[1;34m'
NO_COLOR='\033[0m'
# use the following for a quick copy-paste reference
# echo -e "${PURPLE}${NO_COLOR}"

# -- expressions 
#	see the following resources:
#	    expr --help
#	    let --help
# NOTE: You can't handle decimals with standard expressions THIS IS ALL INTEGER MATH!!!
#	See man 1 bc for a way to handle decimals
echo -e "${PURPLE}Here we use expr, \$(()), and let to evaluate some expressions${NO_COLOR}"

# let evaluates expressions -- see let --help
let x=12+4
echo "\$x=$x"

# expr also evaluates expressions and is very portable/old school
y=`expr $x + 23`
echo "\$y=$y"

# parentheses expansion is a version of expr (see expr --help where it shows it as a possiblity)
z=$(($x - $y))
echo "\$z=$z"

# -- string length of variables
#	Everything is a string, so this is just the number of characters
#	must use a ${#variable_name} syntax
echo -e "\n${PURPLE}Here is an example showing how to get string length${NO_COLOR}"
echo "length x = ${#x}"
echo "length y = ${#y}"
echo "length z = ${#z}"

# -- special string operations
#	if you use double brackets, e.g. [[ "$1" > "$2" ]], you can do string specific comparisons in bash and ksh
echo -e "\n${PURPLE}Special String Operations Example${NO_COLOR}"
echo -n "[[ \"\$x\" > \"\$y\" ]] returns: "
if [[ "$x" > "$y" ]]
then 
    echo "\$x is greater"
else 
    echo "\$y is greater than or equal" 
fi

# -- substrings
#	substr(string, offset, [length]) is done with the following syntax:
#	    ${variable:offest:length} or ${variable:offset}
#	    Note, since I work in Ubuntu, /bin/sh (which is really /bin/dash) doesn't support this
#	    Substrings aren't POSIX standard
example_full="This is our full example string, it is a somewhat long string that has a bunch of words in it"
EXAMPLE_OFFSET=20
example_first_part=${example_full:0:${EXAMPLE_OFFSET}}
example_second_part=${example_full:${EXAMPLE_OFFSET}}
example_stripped_from_end=${example_full: -${EXAMPLE_OFFSET}} # the space between the colon and the -5 is essential here
echo -e "${PURPLE}Here we have some substring examples${NO_COLOR}"
echo $example_full
echo $example_first_part
echo $example_second_part
echo $example_stripped_from_end
