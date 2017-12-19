#!/bin/bash

p1="myout/0.005_10/" 
p2="myout/0.005_5/"
p3="myout/0.05_10/"
p4="myout/0.05_5/"
p5="myout/0.01_10/"
p6="myout/0.01_5/"

PATHLIST=($p1 $p2 $p3 $p4 $p5 $p6)

for p in "${PATHLIST[@]}";
do
    ./scripts/extract_myGT.sh ${p} > ${p}GT_count.txt
# conceptual error
#    ./scripts/counting_GT_from_genes.sh ${p} ${p}union_genes.txt > ${p}union_GT_count.txt
#    ./scripts/counting_GT_from_genes.sh ${p} ${p}germline_genes.txt > ${p}germline_GT_count.txt
#    ./scripts/counting_GT_from_genes.sh ${p} ${p}somatic_genes.txt > ${p}somatic_GT_count.txt
done

