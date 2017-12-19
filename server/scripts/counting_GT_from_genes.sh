#!/bin/bash

FOLDER=$1
GENELIST=$2

# a($16)=NORMAL b($17)=TUMOR
# GENE=$6 (in *.out.gz)
for f in "$FOLDER"*.out.gz;
do
    awk 'NR==FNR{genelist[$1];next} ($6 in genelist)' $GENELIST <(zcat -f $f) | \
    awk '{split($16,a,":"); split($17,b,":"); print a[1], b[1]}'
done | sort | uniq -c 
