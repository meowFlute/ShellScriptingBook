#!/bin/bash

# Colors to differentiate my notes from program execution
PURPLE='\033[1;34m'
NO_COLOR='\033[0m'
# use the following for a quick copy-paste reference
# echo -e "${PURPLE}${NO_COLOR}"

# GLOBBING
# Globbing has two main characters '?' and '*'
#     * = matches any sequence of characters INCLUDING NO CHARACTERS
#     ? = matches any single character, NOT INCLUDING NO CHARACTERS
echo -e "${PURPLE}Example of the usage of the '*' and '?' characters${NO_COLOR}"
echo "ls ch0*4*: $(ls ch0*4*)" # this example will list all ch04 files when run in this directory
echo "ls ch0?4*: $(ls ch0?4*)" # this example will not list anything when run in this directory
echo "ls ch?4*: $(ls ch?4*)"   # this example will work because ? will match with 0

# another similarly useful bash shell feature is the ability to expand a list of strings within curly brackets
echo
echo -e "${PURPLE}Example of string lists using curly brackets${NO_COLOR}"
echo -e "ls ch{03,04}*:\n$(ls ch{03,04}*)" 
# you can use the same trick with other commands and it will expand them all one at a time
# e.g. "mkdir -p ch{01,02,03,04,05,06}" will create 6 directories names ch01 through ch06

# some parts of regular expressions also work for matching
echo -e "${PURPLE}Example using character classes${NO_COLOR}"
echo -e "ls ch[[:digit:]]*:\n$(ls ch[0-9]*)" # NOTE: The '*' in this example is a glob, not a regex *

# There exist character classes, but note that they are expanded including their own set of brackets, so they need to be enclosed within brackets
# [[:alpha:]] = [[:lower:]] and [[:upper:]] = [A-Za-z]
# [[:alnum:]] = [[:alpha:]] and [[:digit:]] = [0-9A-Za-z]
# [[:blank:]] = Blank characters: space and tab.
# [[:cntrl:]] = Control characters. In ASCII, these characters have octal codes 000 through 037, and 177 (DEL).
# [[:digit:]] = [0-9]
# [[:graph:]] = [:alnum:] and [:punct:]
# [[:lower:]] = [a-z]
# [[:print:]] = [:alnum:], [:punct:], and [:space:]
# [[:punct:]] = [! " # $ % & ' ( ) * + , - . / : ; < = > ? @ [ \ ] ^ _ ` { | } ~.]
# [[:space:]] = Space characters: in the ‘C’ locale, this is tab, newline, vertical tab, form feed, carriage return, and space.
# [[:upper:]] = [A-Z]
# [[:xdigit:]] = Hexadecimal digits: 0 1 2 3 4 5 6 7 8 9 A B C D E F a b c d e f.

# You can disable globbing like below in this trivial example of naming and removing a dumb filename that would otherwise destroy what we have
set -o noglob # this disables globbing so we don't mess with existing files matching the ch0* pattern
touch ch0*    # this would normally update the timestamps of all files starting with ch0 in this directory (but won't thanks to not globbing)
echo
echo -e "${PURPLE}You see only the file ch0* below because we disabled globbing${NO_COLOR}"
ls -l ch0*    # this would normally list all files starting with ch0 (but won't thanks to not globbing)
set +o noglob # this enables globbing again
echo -e "${PURPLE}Now we reenabled globbing and you'll see them all, note how the touch command didn't mess with the timestamps of the existing files${NO_COLOR}"
ls -l ch0*
echo -e "${PURPLE}Now we'll disable globbing so we can remove the ch0* file${NO_COLOR}"
set -o noglob
rm ch0*       # this would normally delete all files starting with ch0 (but won't thanks to not globbing)
set +o noglob
ls -l ch0*
echo -e "${PURPLE}See, it is gone!${NO_COLOR}"

# Shell Options
# you can set shell options with shopt -s [OPTION] and unset them with shopt -u [OPTION]
# you can query a state with shopt [OPTION] for a text result or shopt -q [OPTION] for a return value (can query right after with $?, 0 = on, 1 = off)
# -- dotglob
#       This option helps when you want to be able to match a hidden file (starting with '.', like .bashrc) 
touch .hidden_file
echo
echo -e "${PURPLE}here we query for all files but don't see any hidden files:${NO_COLOR}"
ls *
shopt -s dotglob
echo -e "${PURPLE}We'll set dotglob, and we can try again:${NO_COLOR} $(shopt dotglob)"
ls *
rm .hidden_file # clean up
shopt -u dotglob
# -- nullglob 
#       if you don't want a non-matching glob to expand to a literal string, you can make it expand to a nullstring to keep output nice
echo
echo -e "${PURPLE}Here is the nullglob example, where nullglob removes the bad error that happens when z* matches nothing:${NO_COLOR}"
for filename in ch0* z*
do
    md5sum $filename
done
shopt -s nullglob
echo -e "${PURPLE}Now again with nullglob set, so z* evalutes to an empty string instead of \"z*\"${NO_COLOR}"
for filename in ch0* z*
do
    md5sum $filename
done
shopt -u nullglob
# -- failglob 
#       failgob is another way of dealing with the case where the glob matches no patterns.
#       it makes it so bash treats it as an error rather than processing it (still returns an error though)
echo
echo -e "${PURPLE}Here we don't have failglob set, so \"ls z*\" will return an ls error:${NO_COLOR} $(shopt failglob)"
ls z*
shopt -s failglob
echo -e "${PURPLE}Now we've set failglob and run the same command:${NO_COLOR} $(shopt failglob)"
ls z*
shopt -u failglob
echo -e "${PURPLE}So you see a bash error above (the ls command was never run)${NO_COLOR}"
# -- extglob
#       The most powerful but least documented shell option for globbing! 
#       it allows you to use an extended set of pattern matching rules captured in parentheses, as shown here:
#           - pattern-list is a pipe separated list of patterns, e.g. (a|bc|.txt|.php)
#           - ?(pattern-list) matches zero or one of the patterns
#           - *(pattern-list) matches zero or more of the patterns
#           - +(pattern-list) matches one or more of the patterns
#           - @(pattern-list) matches exactly one pattern
#           - !(pattern-list) anything but one of the patterns
shopt -s extglob
echo
echo -e "${PURPLE}Here we'll make a fictitous set of files using touch, ls them and then do examples with extglob${NO_COLOR}\nls a*"
touch a a.txt a.php a.txt.txt abc abctxt abcdef
ls a*
echo -e "${PURPLE}Now we deploy the extglob specials${NO_COLOR}"
echo "$(shopt extglob)"
echo "ls a!(txt)"
ls abc!(txt)
echo "ls a+(.php|.txt)"
ls a+(.php|.txt)
echo "ls a@(.php|.txt)"
ls a@(.php|.txt)
echo "ls a*(.php|.txt)"
ls a*(.php|.txt)
echo "ls a?(.php|.txt)"
ls a?(.php|.txt)
rm a a.txt a.php a.txt.txt abc abctxt abcdef
shopt -u extglob
# -- nocaseglob
#       makes the glob case insenstitive
echo
echo -e "${PURPLE}Here you'll see how nocaseglob makes globbing case insensitive${NO_COLOR}"
touch abc ABC Abc aBC
echo "$(shopt nocaseglob)"
echo "ls [aA]*"
ls [aA]*
echo "ls a*"
ls a*
shopt -s nocaseglob
echo "$(shopt nocaseglob)"
echo "ls a*"
ls a*
shopt -u nocaseglob
rm abc ABC Abc aBC

