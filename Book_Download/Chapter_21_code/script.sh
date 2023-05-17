#!/bin/bash
. gettext.sh
export TEXTDOMAIN=mynicescript
cd `dirname $0`
export TEXTDOMAINDIR=`pwd`/po

savedir=`gettext "savedfiles"`
mkdir ~/.$savedir

gettext "Hello, world!"
echo
gettext "Welcome to the script."
echo

###i18n: Thank you for translating this script!
###i18n: Please leave $RANDOM intact :-)
eval_gettext "Here's a random number: \${RANDOM}"
echo
eval_gettext "Here's another: \$RANDOM"
echo
echo
for i in 2 4 6
do
  ans=`expr $i \* 2`
  eval_gettext "Twice \$i is \$ans"
  echo
done

for i in 1 2 3
do
  eval_ngettext "I have \$i child." "I have \$i children." $i
  echo
done
