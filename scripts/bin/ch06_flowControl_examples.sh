#!/bin/bash

# Colors to differentiate my notes from program execution
PURPLE='\033[1;34m'
NO_COLOR='\033[0m'
# use the following for a quick copy-paste reference
# echo -e "${PURPLE}${NO_COLOR}"

# -- For Loops
#	array created in the for loop definiton
echo -e "${PURPLE}For Loop Examples${NO_COLOR}"
echo -e "${PURPLE}In this first example, we create the array directly in the for loop${NO_COLOR}"
for fruit in pineapple banana orange apple pear
do
    echo $fruit
done
#	array of strings passed in as a variable
echo -e "${PURPLE}It also works to have them coming from a variable${NO_COLOR}"
fruits="pineapple banana orange apple pear"
for fruit in $fruits
do
    echo $fruit
done

#	$* expands to all of the arguments passed in from the command line (excluding $0) so that is another possibility for argument processing
#	alternatively you can do the same thing as above by leaving out the "in list" part (e.g. for fruit\n)
#	here are two examples
echo -e "${PURPLE}These two lists show how to process arguments explicitly and implicitly${NO_COLOR}"
process_args_explicit()
{
    for fruit in $*
    do
	echo $fruit
    done
}

process_args_implicit()
{
    for fruit
    do
	echo $fruit
    done
}

process_args_explicit pineapple banana orange apple pear
process_args_implicit pineapple banana orange apple pear

#	wildcard expansion offers another opportunity
echo -e "${PURPLE}This example just shows wildcard expansion${NO_COLOR}"
for file in $(dirname $0)/*
do
    echo $file
done
echo -e "${PURPLE}NOTE: the \"for\" command line is read and expanded only once, so the following doesn't make an infinite loop${NO_COLOR}"
for file in $(dirname $0)/*
do
    if [ -f $file ]
    then
	cp $file $file.bak
    fi
done
ls $(dirname $0)
echo -e "${PURPLE}deleting temporary .bak files${NO_COLOR}"
rm $(dirname $0)/*.bak

#	final example for bash-style for-loops:
#	if the array is empty they just are skipped
echo -e "${PURPLE}If there is nothing between this line and the next colored output line, it shows shell for loops skip if empty${NO_COLOR}"
meows=
for meow in $meows
do
    echo $meow
done
echo -e "${PURPLE}Is this line prceeded by any output?${NO_COLOR}"

# -- C-Style For Loops
#	Isn't this the same thing??? OF COURSE NOT!
#	Just add an extra set of parentheses
echo -e "\n${PURPLE}You can do C-style For Loops!${NO_COLOR}"
for ((i=0; i<10; i++))
do
    printf "i=%d\n" $i
done
#	The book even shows you can do weird comma-separated versions that run multiple conditions simultaneously
for ((i=0, j=10; i<10, j>0; i++, j--))
do
    printf "i=%02d, j=%02d\n" $i $j
done

# -- While Loops
#	The author kind of goes off on a tangent here, but the main things presented that are useful are:
#	    1) a while loop will continue until NON-ZERO returns from test, this means you can have basically any program as a test
#	    2) "until" is a negated while (i.e. all testing logic is negated (TRUE && TRUE) becomes (FALSE || FALSE)
#	    3) a while loop is a single command -- you can write from or to it in one go (no need for appending)
#	    4) break and continue are available (e.g. in a case statement that could be clutch)
echo
echo -e "${PURPLE}Here is a simple example of a while loop that logs everything into a text file${NO_COLOR}"
i=0
while [ "$i" -le "5" ]
do
    echo "$(date) | $i"
    i=`expr $i + 1`
done > log_file.txt
echo "cat log_file.txt"
cat log_file.txt
rm log_file.txt
# same as above using an until loop
echo -e "${PURPLE}Again now with an until loop${NO_COLOR}"
echo -e "${PURPLE}NOTE: Notice how you don't have to append${NO_COLOR}"
i=0
until [ "$i" -eq "5" ]
do
    echo "$(date) | $i"
    i=`expr $i + 1`
done > log_file.txt
echo "cat log_file.txt"
cat log_file.txt
# notice in this example how the last argument catches the rest of the line. 
# You could do "line" as your variable and grab it all, or you can split it intelligently
echo -e "${PURPLE}Show how you can have a file input to a while loop${NO_COLOR}"
echo -e "${PURPLE}NOTE: This also shows how you can put data into variables${NO_COLOR}"
while read dayname month daynum time ampm timezone year the_rest
do
    echo "$dayname $time $ampm $the_rest"
done < log_file.txt
echo -e "${PURPLE}Finally we demonstrate case-continue-break combos${NO_COLOR}"
while read dayname month daynum time ampm timezone year pipe i
do
    case $i in
	0) echo "Time at the 0th entry was $time"; continue ;;
	1) echo "Day at the 1st entry was $dayname the $daynum" ;;
	2) echo "Month at the 2nd entry was $month" ;;
	*) echo "So long!"; break ;;
    esac
done < log_file.txt
rm log_file.txt

# -- Select Loops
#	A lesser-used tool that provides simple & robust user input for a program
#	The main things to know are:
#	    - set PS3 to decide the prompt (unset PS3 results in #?)
#	    - The user reply goes into $REPLY
#	    - whatever variable you choose gets the string chosen
echo
echo -e "${PURPLE}Select! Let's take a look at how it works${NO_COLOR}"

# we'll save off the old PS3 and reset it later just in case it is something useful
oPS3=$PS3
PS3="Select an option by typing in a number and hitting enter: "
help_prompt="Select an option below! Type \"help\" for help, \"quit\" to quit"
echo "$help_prompt"
select response in "Meow" "Fart" "Joke"
do
    # quit option with a break
    if [ "$REPLY" = "quit" ] || [ "$REPLY" = "Quit" ]
    then
	echo "So long!"
	break
    # help option with a continue
    elif [ "$REPLY" = "help" ] || [ "$REPLY" = "Help" ]
    then
	echo "$help_prompt"
	continue
    fi
    # case for the other responses
    if [ ! -z $response ]
    then
	case $REPLY in
	    1)  echo "Meeeeeow" ;;
	    2)  echo "Pfffffft" ;;
	    3)  echo "Why did the chicken go to the library?"
		sleep 1
		echo "So it could check out a BAWK!!!"
		;;
	esac
    else
	echo "Not a valid selection: $REPLY"
    fi
done
PS3=$oPS3
