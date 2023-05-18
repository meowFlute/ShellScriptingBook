#!/bin/bash

# GLOBBING
# Globbing has two main characters '?' and '*'
#     * = matches any sequence of characters INCLUDING NO CHARACTERS
#     ? = matches any single character, NOT INCLUDING NO CHARACTERS
echo "ls ch0*4*: $(ls ch0*4*)" # this example will list all ch04 files when run in this directory
echo "ls ch0?4*: $(ls ch0?4*)" # this example will not list anything when run in this directory
echo "ls ch?4*: $(ls ch?4*)"   # this example will work because ? will match with 0

# another similarly useful bash shell feature is the ability to expand a list of strings within curly brackets
echo
echo "ls ch{03,04}*: $(ls ch{03,04}*)" 
# you can use the same trick with other commands and it will expand them all one at a time
# e.g. "mkdir -p ch{01,02,03,04,05,06}" will create 6 directories names ch01 through ch06

# some parts of regular expressions also work for matching
echo "ls ch[0-9]*: $(ls ch[0-9]*)" # NOTE: The '*' in this example is a glob, not a regex *


