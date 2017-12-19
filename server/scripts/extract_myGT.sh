#!/bin/bash

FOLDER=$1
#OUTF=$2

#if [ ! -d "$OUTF" ]; then
#    mkdir $OUTF;
#fi

# check the file extension
# a($16)=NORMAL b($17)=TUMOR
for f in "$FOLDER"*.out.gz;
do
    awk '!/^#/ {split($16,a,":"); split($17,b,":"); print a[1], b[1]}' <(zcat -f $f)
done | sort | uniq -c 
