#!/bin/bash

for mce in `wc -l /var/reports/mcelogs/*.log | grep -vw "0 "`
do
  gzip $mce
done
