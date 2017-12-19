#!/bin/bash

INF=$1
#OF=$2
OF=$INF"new"
exonic_func="synonymous_SNV"

mkdir ${OF}

for f in "$INF"*.out.gz;
do
    awk -f scripts/add_germline_somatic.awk <(zcat $f) | \
        awk \
            -v ef="$exonic_func" \
            -v mt="germline" \
            '{if($8!=ef && $8!="." && tolower($8)!="unknown" && $NF==mt) print $6}' | sort -u
done | sort | uniq -c | sort -nrk 1 | awk '{print $2, $1}' \
    > ${OF}/allbutsyn_germline_genes.txt

for f in "$INF"*.out.gz;
do
    zcat $f | awk \
        -v ef="$exonic_func" \
        '!/^#/{if($8!=ef && $8!="." && tolower($8)!="unknown") print $6}' | sort -u
done | sort | uniq -c | sort -nrk 1 | awk '{print $2, $1}' \
    > ${OF}/allbutsyn_tumor_genes.txt
