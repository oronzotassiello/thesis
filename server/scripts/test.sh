#!/bin/bash

CHR_LIST=$1
PZ_LIST=$2

IFS=$'\n'
for pz in $(cat < "$PZ_LIST");
do
    for chr in $(cat < "$CHR_LIST");
    do
        zcat $chr >/dev/null
    done 
done
