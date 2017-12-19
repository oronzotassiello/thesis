#!/bin/bash

TCGA_FILE=$1  # list of pathogenic tcga genes
OTG_FILE=$2   # list of pathogenic otg genes
N_TCGA=$3
N_OTG=$4
OF=$5

exonic_func="nonsynonymous_SNV"

genes_tcga_germline=${OF}/genes_tcga_germline_${exonic_func}.tmp
genes_tcga_tumor=${OF}/genes_tcga_tumor_${exonic_func}.tmp
genes_otg=${OF}/genes_otg_${exonic_func}.tmp

genes_ctable=${OF}/genes_ctable_${exonic_func}.txt

# extracting germline genes from tcga
cat $TCGA_FILE | awk '{print $1,$2,$3,$4,$5,$6,$7,$8}' | sort | uniq | \
awk -f scripts/add_germline_somatic.awk | \
    awk \
        -v ef="$exonic_func" \
        -v mt="germline" \
        '{if($8==ef && $NF==mt) print $6}' | \
        sort | uniq -c | sort -nrk1 | awk '{print $2, $1}' > $genes_tcga_germline

# extractiong tumor genes from tcga
cat $TCGA_FILE | awk '{print $1,$2,$3,$4,$5,$6,$7,$8}' | sort | uniq | \
awk -v ef="$exonic_func" '{if($8==ef) print $6}' | \
sort | uniq -c | sort -nrk1 | awk '{print $2, $1}' > $genes_tcga_tumor

# extracting genes from otg db
cat $OTG_FILE | awk '{print $1,$2,$3,$4,$5,$6,$7,$8}' | sort | uniq | \
awk -v ef="$exonic_func" '{if($8==ef) print $6}' | \
sort | uniq -c | sort -nrk1 | awk '{print $2, $1}' > $genes_otg

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
