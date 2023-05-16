#!/bin/bash
hyperthreads=1
grep -w "^flags" /proc/cpuinfo | grep -qw "ht" && hyperthreads=2
phys=`grep "physical id" /proc/cpuinfo | sort -u | wc -l`
cores=`grep "core id" /proc/cpuinfo | sort -u | wc -l`
threads=`expr $phys \* $cores \* $hyperthreads`
detail=`grep "model name" /proc/cpuinfo | sort -u | cut -d: -f2- | \
    cut -c2- | tr -s " "`
echo "`hostname -s` has $phys physical CPUs ($detail) each with $cores cores."
echo "Each core has $hyperthreads threads: total $threads threads"
