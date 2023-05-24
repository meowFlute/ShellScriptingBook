#!/bin/bash

# bring in my colorized echo library
echo_colors_path="$(dirname $0)/../lib/echo_colors"
[ -z "$_echo_colors" ] && . $echo_colors_path

print_array()
{
    arr=( $@ ) # expanding the array results in a bunch of arguments
    # remember that bash has c-style for loops
    for ((i = 0; i < ${#arr[@]}; i++))
    do
	echo "index $i: ${arr[$i]}"
    done
}

# -- Assigning Arrays (GREEN SECTION IN OUTPUT)
#	Arrays can be assigned:
#	    - One at a time
#	    - All at once
#	    - By index
#	    - All at once from a source
#		> You can also read a file line by line by changing IFS="\n", just remember to save it and reset it using oIFS or something
#	    - Read from input
echo_colorized -fb -bg "   ASSIGNING ARRAYS   "
# one at a time example
echo_colorized -fg "First we'll do a quick example of initializing and array one at a time"
example_array[0]=zero
example_array[1]=one
example_array[2]=two
print_array ${example_array[@]}

# all at once example
echo_colorized -fg "\nNext all at once without indices"
example_array=( zero one two three four five six )
print_array ${example_array[@]}

# by index example
echo_colorized -fg "\nNow we'll do it by index"
# note how the array:
#   - can be declared out of order and it will rearrange
#   - can be sparse and it won't change its total length
example_array=( [3]=cats [40]=are [5]=my [10]=favorite )
print_array ${example_array[@]}

# all at once from source
echo_colorized -fg "\nHere we do it all at once from a source (the first 10 elements of cat /proc/\$\$/stat in this case)"
stat=( $(cat /proc/$$/stat) )
print_array ${stat[@]:0:10}
echo_colorized -fg "Same thing, but changing IFS to the newline character so we can read a file line by line into an array"
oIFS=$IFS
IFS=`echo -e '\n' | cat -v`
hosts=( `cat /etc/hosts` )
print_array ${hosts[@]:0:10}
IFS=$oIFS # reset this to whatever it was
# obviously you could edit it to break on commas, colons, etc.

# read from input
echo_colorized -fg "\nLast but not least, here is an example of using the read -a option"
echo -n "Please enter gibberish separated by spaces, tabs, or newline characters so I can put it into an array: "
read -a example_array
print_array ${example_array[@]}

# -- Accessing Arrays (PINK)
#	- Accessing by index (shown above)
#	- Length of arrays (shown in the function print_array)
#	- Accessing by Variable Index (shown in the function print_array)
#	- Selecting items from an array
#	- Displaying the entire array
echo
echo_colorized -fb -bP "   ACCESSING ARRAYS   "
echo_colorized -fP "We did some accessing and selecting above, but here is another example"
example_array=( I want to eat an indian pizza for dinner. I think I will get a chicken tikka pizza from Pizzawallas Desi Pizza )
print_array ${example_array[@]}
echo_colorized -fP "Now we select from the above string starting at the 9th index"
print_array ${example_array[@]:9}

# Dispaying the array
echo_colorized -fP "\nYou can display the whole array very simply thanks to expansion and echo being ok with a lot of arguments"
echo ${example_array[@]}

# associative arrays 
#	- just use the "declare -A arr_name" syntax
echo
echo_colorized -by -fb "   Associative Arrays   "
echo_colorized -fy "Associative array example"
declare -A cat_nicknames
cat_nicknames=( [gus]="guster girl" [fred]="tiger tail" )
# you can refer back to either field, like so
for cat_name in ${!cat_nicknames[@]}
do
    echo "The cat named $cat_name is also known as ${cat_nicknames[$cat_name]}"
done
