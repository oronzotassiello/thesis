#!/bin/bash

# generic script to execute same command on all myout folders

#p1="myout/tcga/0.005_10/" 
#p2="myout/tcga/0.005_5/"
#p3="myout/tcga/0.05_10/"
#p4="myout/tcga/0.05_5/"
#p5="myout/tcga/0.01_10/"
#p6="myout/tcga/0.01_5/"

#PATHLIST=($p1 $p2 $p3 $p4 $p5 $p6)

#MUT_FILE=$1

PATHLIST=("01_5" "01_10" "005_5" "005_10" "05_5" "05_10")


# OTGPATH=("05" "01" "005")
# for p in "${OTGPATH[@]}";
# do
#     out="/home/um99/rnz/data/pathogenic/otg/"${p}
#     mkdir -p $out
#     
#     ./scripts/filter_pathogenic.sh myout/otg/${p}/split/ $MUT_FILE $out
# done

for p in "${PATHLIST[@]}";
do
    out="/home/um99/rnz/data/pathogenic/bootstrap/"${p}
    mkdir -p $out

    ./scripts/repeat_n_times.sh data/pathogenic/tcga/${p}/ data/pathogenic/otg/${p%_*}/ 250 $out

#    out="/home/um99/rnz/data/pathogenic/tcga/"${p}
#    mkdir -p $out
#    
#    ./scripts/filter_pathogenic.sh myout/tcga/0.${p}/ $MUT_FILE $out

#    out="/home/um99/rnz/data/bootstrap/"${p}
#    mkdir $out
#
#    ./scripts/repeat_n_times.sh myout/tcga/0.${p}/ myout/otg/${p%_*}/split/ 250 $out

# repeting gene counting becouse of error spot in old script
#    rm -ri ${p}"new"
#    ./scripts/allbutsyn_gene_counting_REVIEW.sh ${p}

#    python scripts/computeFisher.py \
#        <(awk '{print $1, $3, $4}' tables/gene_counting_cmp/tcga_otg_${p}_allbutsyn.txt) --std \
#        > tables/fisher_test/fisher_tumor_otg_${p}_allbutsyn.txt
#
#    python scripts/computeFisher.py \
#        <(awk '{print $1, $3, $4}' tables/gene_counting_cmp/tcga_otg_${p}_nonsyn.txt) --std \
#        > tables/fisher_test/fisher_tumor_otg_${p}_nonsyn.txt

#    python vcf-parsing/genes_uninon.py \
#        <(awk '{print $1, $2, $3}' myout/0.${p}/nonsyn_union_genes.txt) \
#        <(awk '{print $2, $1}' myout/otg/${p%_*}/gene_counting_nonsyn.txt) \
#    > tables/tcga_otg_${p}_nonsyn.txt
#
#    python vcf-parsing/genes_uninon.py \
#        <(awk '{print $1, $2, $3}' myout/0.${p}/allbutsyn_union_genes.txt) \
#        <(awk '{print $2, $1}' myout/otg/${p%_*}/gene_counting_allbutsyn.txt) \
#    > tables/tcga_otg_${p}_allbutsyn.txt

#    printf ${p}'\n'
#    cat ${p}nonsyn_union_genes.txt | wc -l
#    cat ${p}allbutsyn_union_genes.txt | wc -l

#    python vcf-parsing/genes_uninon.py ${p}allbutsyn_germline_genes.txt ${p}allbutsyn_tumor_genes.txt | \
#        awk '{print $0, $3-$2}' | sort -nrk 4 > ${p}allbutsyn_union_genes.txt &\
#    python vcf-parsing/genes_uninon.py ${p}nonsyn_germline_genes.txt ${p}nonsyn_tumor_genes.txt | \
#        awk '{print $0, $3-$2}' | sort -nrk 4 > ${p}nonsyn_union_genes.txt
#
    # gene counting
#    ./scripts/allbutsyn_gene_counting.sh ${p}
#    ./scripts/allnonsyn_gene_counting.sh ${p}
#    mkdir ${p}bkp
#    mv ${p}*.txt ${p}bkp/
#    mv ${p}bkp/GT_count.txt ${p}/
done

