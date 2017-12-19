#!/bin/bash

FOLDER=$1
OUTF=$2

if [ ! -d "$OUTF" ]; then
    mkdir $OUTF;
fi

# check the file extension
# a($10)=NORMAL b($11)=TUMOR
for f in "$FOLDER"*.vcf.gz;
do
    awk '!/^#/ {split($10,a,":"); split($11,b,":"); print a[1], b[1]}' <(zcat $f)
done | gzip > ${OUTF}/allGT.out.gz
