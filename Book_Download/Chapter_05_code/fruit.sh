#!/bin/bash

read -p "What is your favorite fruit?: " fruit
case $fruit in
  orange) echo "The $fruit is orange" ;;
  banana) echo "The $fruit is yellow" ;;
  pear) echo "The $fruit is green" ;;
  *) echo "I don't know what colour a $fruit is" ;;
esac
