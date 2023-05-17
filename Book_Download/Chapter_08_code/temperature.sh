#!/bin/bash

convert()
{
  # Set defaults
  quiet=0
  scale=0
  error=0
  source=centigrade

  # Reset optind between calls to getopts
  OPTIND=1
  while getopts 'c:f:s:q?' opt
  do
    case "$opt" in
      "c") centigrade=$OPTARG
           source=centigrade ;;
      "f") fahrenheit=$OPTARG
           source=fahrenheit  ;;
      "s") scale=$OPTARG ;;
      "q") quiet=1 ;;
      *) echo "Usage: convert [ -c | -f ] temperature [ -s scale | -q ]"
         error=1
         return 0 ;;
    esac
  done

  if [ "$quiet" -eq "1" ] && [ "$scale" != "0" ]; then
    echo "Error: Quiet and Scale are mutually exclusive."
    echo "Quiet can only return whole numbers between 0 and 255."
    exit 1
  fi

  case $source in
    centigrade)
      fahrenheit=`echo scale=$scale \; $centigrade \* 9 / 5 + 32 | bc`
      answer="$centigrade degrees Centigrade is $fahrenheit degrees Fahrenheit"
      result=$fahrenheit
      ;;
    fahrenheit)
      centigrade=`echo scale=$scale \; \($fahrenheit - 32\) \* 5 / 9 | bc`
      answer="$fahrenheit degrees Fahrenheit is $centigrade degrees Centigrade "
      result=$centigrade
      ;;
    *)
      echo "An error occurred."
      exit 0
      ;;
  esac
  if [ "$quiet" -eq "1" ]; then
    if [ "$result" -gt "255" ] || [ "$result" -lt "0" ]; then
      # scale has already been tested for; it must be an integer.
      echo "An error occurred."
      echo "Can't return values outside the range 0-255 when quiet."
      error=1
      return 0
    fi
    return $result
  else
    echo $answer
  fi
}

# Main script starts here.

echo "First by return code..."
convert -q -c $1
result=$?
if [ "$error" -eq "0" ]; then
  echo "${1}C is ${result}F."
fi

convert -f $1 -q
result=$?
if [ "$error" -eq "0" ]; then
  echo "${1}F is ${result}C."
fi

echo

echo "Then within the function..."
convert -f $1
convert -c $1

echo

echo "And now with more precision..."
convert -f $1 -s 2
convert -s 3 -c $1
