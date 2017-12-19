#!/bin/bash

CHR_LIST=$1
PZ_LIST=$2
PY_FILTER=$3
OUT_DIR=$4

IFS=$'\n'
for pz in $(cat < "$PZ_LIST");
do
    for chr in $(cat < "$CHR_LIST");
    do
        awk -v p="$pz" -v out="$OUT_DIR" '!/^#/{
            split(p, pz_i);
            split($pz_i[1], sp, ":");
            if (sp[1] != "0|0" && sp[1] != "0" && sp[1] != "."){
                printf("%s %s %s %s %s %s %s %s %s %s\n", 
                $1, $2, $3, $4, $5, $6, $7, $8, $9, $pz_i[1])
            } 
        }' <(zcat $chr);
    done > $OUT_DIR"/"$(awk 'BEGIN{split(ARGV[1],p); print p[2]}' $pz)".end_append.vcf"
done
