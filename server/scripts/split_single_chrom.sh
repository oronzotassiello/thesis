#!/bin/bash

CHR_DIR=$1
PY_FILTER=$2
OUT_DIR=$3

start="10"

for chr in "$CHR_DIR"*.vcf.gz;
do
    awk -v col="$start" -v out="$OUT_DIR" '{
        if (/^#CHROM/) {
            split($0,data,"\t")
            n=length(data)
            for (i=col; i<=NF; i++) 
                pz_list[i]=$i
        } 
        else {
            if(substr($0,1,1) != "#"){
                split($0,data,"\t")
                for (i=col; i<=n; i++){
                    split(data[i], sp, ":");
                    if (sp[1] != "0|0" && sp[1] != "0" && sp[1] != "."){
                        print $1,$2,$3,$4,$5,$6,$7,$8,$9,data[i] >> out"/"pz_list[i]".tmp.vcf"  
                    }
                }
            }
        }
    }' <(zcat -f $chr)

    for pz in "$OUT_DIR"*.tmp.vcf;
    do
        python "$PY_FILTER" "$pz" -f 0.05 --append --out "$OUT_DIR"
        rm $pz
    done
done
