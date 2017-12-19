#!/bin/bash

INF=$1
#OF=$2
OF=$INF
exonic_func="synonymous_SNV"

rm ${OF}/syn_tumor.tmp ${OF}/syn_germline.tmp 2>/dev/null

for f in "$INF"*.out.gz;
do
    awk -f scripts/add_germline_somatic.awk <(zcat $f) | tee \
        >(awk \
            -v ef="$exonic_func" \
            -v mt="germline" \
            '{if($8<=ef && $NF==mt) print $6}' | sort -u >> ${OF}/syn_germline.tmp) \
        >(awk \
            -v ef="$exonic_func" \
            '{if($8<=ef) print $6}' | sort -u >> ${OF}/syn_tumor.tmp) \
        &>/dev/null;
done

cat ${OF}/syn_germline.tmp | sort | uniq -c | sort -nrk 1 | awk '{print $2, $1}' \
    > ${OF}/allbutsyn_germline_genes.txt

cat ${OF}/syn_tumor.tmp | sort | uniq -c | sort -nrk 1 | awk '{print $2, $1}' \
    > ${OF}/allbutsyn_tumor_genes.txt

rm ${OF}/syn_tumor.tmp ${OF}/syn_germline.tmp
