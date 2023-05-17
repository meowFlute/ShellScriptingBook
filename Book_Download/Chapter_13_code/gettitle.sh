#!/bin/bash

grep "<title>" *.html | while read html
do
   filename=`echo $html | cut -d: -f1`
   title=`echo $html | cut -d">" -f2- | cut -d"<" -f1`
   echo "$filename = $title"
done 
