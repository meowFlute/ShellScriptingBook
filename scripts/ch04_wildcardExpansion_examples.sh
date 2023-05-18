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
# [[:space:] = Space characters: in the ‘C’ locale, this is tab, newline, vertical tab, form feed, carriage return, and space.
# [[:upper:]] = [A-Z]
# [[:xdigit:]] = Hexadecimal digits: 0 1 2 3 4 5 6 7 8 9 A B C D E F a b c d e f.

# You can disable globbing like below in this trivial example of naming and removing a dumb filename that would otherwise destroy what we have

