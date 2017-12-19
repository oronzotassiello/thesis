#!/bin/bash

FOLDER=$1
OUTF=$2

if [ ! -d "$OUTF" ]; then
    mkdir $OUTF;
fi

# check the file extension
for f in "$FOLDER"*;
do
    python /home/um99/rnz/vcf-parsing/main_vcfnnvrprsr.py $f \
       -t tumor \
       -f 0.40 \
       --SPV 0.1 \
       --AAFreq 50 \
       --out $OUTF;
done

