#!/bin/bash

TCGA_DIR=$1
OTG_DIR=$2
N_TCGA=$3
N_OTG=$4
OF=$5

exonic_func="synonymous_SNV"

genes_tcga_germline=${OF}/genes_tcga_germline_allbut${exonic_func}.tmp
genes_tcga_tumor=${OF}/genes_tcga_tumor_allbut${exonic_func}.tmp
genes_otg=${OF}/genes_otg_allbut${exonic_func}.tmp

genes_ctable=${OF}/genes_ctable_allbut${exonic_func}.txt

# extracting germline genes from tcga
for f in $(ls "$TCGA_DIR"*.out.gz);
do
    awk -f scripts/add_germline_somatic.awk <(zcat $f) | \
        awk \
            -v ef="$exonic_func" \
            -v mt="germline" \
            '{if($8!=ef && $8!="." && tolower($8)!="unknown" && $NF==mt) print $6}' | sort -u
done | sort | uniq -c | sort -nrk1 | awk '{print $2, $1}' > $genes_tcga_germline

# extractiong tumor genes from tcga
for f in $(ls "$TCGA_DIR"*.out.gz);
do
    zcat $f | awk -v ef="$exonic_func" '{!/^#/{if($8!=ef && $8!="." && tolower($8)!="unknown") print $6}' | sort -u 
done | sort | uniq -c | sort -nrk1 | awk '{print $2, $1}' > $genes_tcga_tumor

# extracting genes from otg db
for f in $(ls "$OTG_DIR"*.gz);
do
    zcat $f | awk -v ef="$exonic_func" '{if($8!=ef && $8!="." && tolower($8)!="unknown") print $6}' | sort -u
done | sort | uniq -c | sort -nrk1 | awk '{print $2, $1}' > $genes_otg

# union genes otg tcga_germline > res.tmp
python scripts/genes_union.py $genes_otg $genes_tcga_germline > res.tmp

# union genes res.tmp tcga_tumor > merge.txt
python scripts/genes_union.py res.tmp $genes_tcga_tumor > genes_merge.tmp

# compute contingency matrix merge.txt for each line > ctable.txt
# GENE | otg | otg ^mut | tcga germ | tcga germ ^mut | tcga tumor | tcga tumor ^mut |
awk -v nt="$N_TCGA" -v n1kg="$N_OTG" 'OFS="\t"{print $1, $2, n1kg-$2, $3, nt-$3, $4, nt-$4}' genes_merge.tmp > $genes_ctable

# compute fisher test three times:
# 1- 1kg vs tumor tcga
python scripts/computeFisher.py <(awk 'OFS="\t"{print $1, $2, $3, $6, $7}' $genes_ctable) --std | sort -nrk 7 > ${OF}/fisher_1kg_tumor_${exonic_func}.txt

# 2- normal tcga vs tumor tcga
python scripts/computeFisher.py <(awk 'OFS="\t"{print $1, $4, $5, $6, $7}' $genes_ctable) --std | sort -nrk 7 > ${OF}/fisher_tcga_normal_tumor_${exonic_func}.txt

# 3- 1kg vs normal tcga
python scripts/computeFisher.py <(awk 'OFS="\t"{print $1, $2, $3, $4, $5}' $genes_ctable) --std | sort -nrk 7 > ${OF}/fisher_1kg_tcga_normal_${exonic_func}.txt

mv *.tmp trash/
