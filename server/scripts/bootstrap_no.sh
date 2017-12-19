#!/bin/bash

TCGA_DIR=$1
OTG_DIR=$2
N=$3
OF=$4

exonic_func="nonsynonymous_SNV"

for f in "$TCGA_DIR"*.out.gz;
do
    awk -f add_germline_somatic.awk <(zcat $f | tail -n +2 | sort -R | head -n ${N}) | \
        awk \
            -v ef="$exonic_func" \
            -v mt="germline" \
            -f list_genes.awk | sort -u
done | sort | uniq -c | sort -nrk1 | awk '{print $2, $1}' > ${OF}/bootstrap_tcga_germline_${exonic_func}.txt

for f in "$TCGA_DIR"*.out.gz;
do
    awk -f add_germline_somatic.awk <(zcat $f | tail -n +2 | sort -R | head -n ${N}) | \
        awk \
            -v ef="$exonic_func" \
            -v mt="somatic" \
            -f list_genes.awk | sort -u 
done | sort | uniq -c | sort -nrk1 | awk '{print $2, $1}' > ${OF}/bootstrap_tcga_somatic_${exonic_func}.txt           

for f in "$OTG_DIR"*.gz;
do
    zcat $f | sort -R | head -n ${N} | awk -v ef="$exonic_func" '{if($8==ef) print $6}' | sort -u
done | sort | uniq -c | sort -nrk1 | awk '{print $2, $1}' > ${OF}/bootstrap_otg_${exonic_func}.txt
