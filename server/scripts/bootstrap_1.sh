#!/bin/bash

TCGA_DIR=$1
OTG_DIR=$2
N=$3
OF=$4

exonic_func="nonsynonymous_SNV"

for f in $(ls "$TCGA_DIR"*.out.gz | sort -R | head -n $N);
do
    awk -f scripts/add_germline_somatic.awk <(zcat $f) | \
        awk \
            -v ef="$exonic_func" \
            -v mt="germline" \
            '{if($8==ef && $NF==mt) print $6}' | sort -u
done | sort | uniq -c | sort -nrk1 | awk '{print $2, $1}' > ${OF}/bootstrap_tcga_germline_${exonic_func}.txt

for f in $(ls "$TCGA_DIR"*.out.gz | sort -R | head -n $N);
do
    awk -f scripts/add_germline_somatic.awk <(zcat $f) | \
        awk \
            -v ef="$exonic_func" \
            '{if($8==ef) print $6}' | sort -u 
done | sort | uniq -c | sort -nrk1 | awk '{print $2, $1}' > ${OF}/bootstrap_tcga_tumor_${exonic_func}.txt           

for f in $(ls "$OTG_DIR"*.gz | sort -R | head -n $N);
do
    zcat $f | awk -v ef="$exonic_func" '{if($8==ef) print $6}' | sort -u
done | sort | uniq -c | sort -nrk1 | awk '{print $2, $1}' > ${OF}/bootstrap_otg_${exonic_func}.txt
