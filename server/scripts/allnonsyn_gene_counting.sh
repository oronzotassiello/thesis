#!/bin/bash

INF=$1
#OF=$2
OF=$INF
exonic_func="nonsynonymous_SNV"

rm ${OF}/tumor.tmp ${OF}/germline.tmp 2>/dev/null

for f in "$INF"*.out.gz;
do
    awk -f scripts/add_germline_somatic.awk <(zcat $f) | tee \
        >(awk \
            -v ef="$exonic_func" \
            -v mt="germline" \
            '{if($8==ef && $NF==mt) print $6}' | sort -u >> ${OF}/germline.tmp) \
        >(awk \
            -v ef="$exonic_func" \
            '{if($8==ef) print $6}' | sort -u >> ${OF}/tumor.tmp) \
        &>/dev/null;
done

cat ${OF}/germline.tmp | sort | uniq -c | sort -nrk 1 | awk '{print $2, $1}' \
    > ${OF}/nonsyn_germline_genes.txt

cat ${OF}/tumor.tmp | sort | uniq -c | sort -nrk 1 | awk '{print $2, $1}' \
    > ${OF}/nonsyn_tumor_genes.txt

rm ${OF}/tumor.tmp ${OF}/germline.tmp
