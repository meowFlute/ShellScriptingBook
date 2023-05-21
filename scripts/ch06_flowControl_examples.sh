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
