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

# -- stripping with patterns
#	1) ${variable#pattern} non-greedy stripping from the beginnig of the string
#	2) ${variable##pattern} greedy stripping from the beginning of the string
#	3) ${variable%word} non-greedy from end of string
#	4) ${variable%%word} greedy from end of string
echo -e "\n${PURPLE}Here we have pattern-stripping examples${NO_COLOR}"
example_nongreedy_front=${example_full#* }
example_greedy_front=${example_full##* }
example_nongreedy_back=${example_full% *}
example_greedy_back=${example_full%% *}
echo $example_nongreedy_front
echo $example_greedy_front
echo $example_nongreedy_back
echo $example_greedy_back

# -- Search and replace
#	This is kind of like the format of sed (or even :s in vim)
#	${variable/find/replace} replaced the first instance only
#	${variable//find/replace} replaces all instances
#	${variable/#find/replace} asserts that "find" must occur at the begining of a line (like the regex ^find)
#	${variable/%find/replace} asserts that "find" must occur at the end (like regex find$) great for filename extensions!
#	${variable/find} with any of the above modifications just deletes (replaces with nothing)
#	Additional Notes:
#	    - shell wildcards * and ? work
echo -e "\n${PURPLE}Here is an example of a search and replace, replacing \"it\" with \"meow\"${NO_COLOR}"
echo ${example_full/it/meow} # this replaces the first instance only
echo ${example_full//it/meow} # replaces all as described above
echo ${example_full/#it/meow} # this does nothing because the regex ^it doesn't match
echo ${example_full/%it/meow} # this does work because the it is equivalent to it$
echo ${example_full//i?/meow} # replaces any i? string with meow (it, is, in, the last couple letters of "This", the "in" in "string" etc.)
echo ${example_full// i* / meow } # globbed replaces basically everything, but works as expected
echo ${example_full// it} # deletes all instances of " it"

# -- Changing case
#	${variable,,} is lower
#	${variable^^} is upper
echo -e "\n${PURPLE}Here is a simple upper and lower case conversion example${NO_COLOR}"
echo ${example_full,,}
echo ${example_full^^}

# -- Default values
#	${variable:-default} sets it only for that specific expansion if the variable is not set
#	${variable:=default} permanently sets the variable if it hasn't previously been set
echo -e "\n${PURPLE}Here are some examples of how to use default values${NO_COLOR}"
meow=
echo "meow:-${meow:-\"default value\"}"
echo $meow
echo "meow:=${meow:=\"default value\"}"
echo $meow

# -- Checking for set
#	being set to nothing and not being set at all are two different things
#	${variable?output} returns output if the variable is not set with a nice variable reference
#	    - This will also cause the shell to exit with a code of 1
#	${variable+output} returns output if the variable is set
echo -e "\n${PURPLE}Here we look at evaluating if a variable is set or not${NO_COLOR}"
meow=
echo "test 1: ${meow?"meow is not set"}"
# unset meow
# echo "test 2: ${meow?"meow is not set"}" # This will cause the shell to quit with an error code of 1
echo "some_program ${DISPLAY+"--display $DISPLAY"}"

# -- Indirection
#	This is how you can programmatically construct variable names
#	I stole the following example from ../Book_Download/Chapter_07*/empdata.sh
#	${!variable} where variable is the name of another variable
echo -e "${PURPLE}This is a great indirection example from the book${NO_COLOR}"
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
    echo -e "${PURPLE}empdata=$empdata, \${!empdata}=${!empdata}${NO_COLOR}"
    echo "${Employee}'s ${Data} is ${!empdata}"	# jim.j@example.com
    break
  done 
  break
done

# -- Sourcing Files
#	You can source files with "." and bash will read all of the variables theirin (and I'm guessing run whatever else it has?)
echo -e "\n${PURPLE}Example showing sourcing functionality. Before setting these variables nothing should happen${NO_COLOR}"

echo "before: $VAR1 $VAR2 $VAR3 $VAR4"
. $(dirname $0)/ch07_variablesContinued_vars
echo "after: $VAR1 $VAR2 $VAR3 $VAR4"

