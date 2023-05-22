#!/bin/bash
# Set input to a known value as we are testing it before we set it
input=""

while [ -z "$input" ]; do
  read -p "Please give your input: " input
done
echo "Thank you for saying $input"
