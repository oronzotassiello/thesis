#!/bin/bash

# generic script to execute same command on all myout folders

p1="myout/0.005_10/" 
p2="myout/0.005_5/"
p3="myout/0.05_10/"
p4="myout/0.05_5/"
p5="myout/0.01_10/"
p6="myout/0.01_5/"

PL=($p1 $p2 $p3 $p4 $p5 $p6)
echo ${PL[@]}

for ((i=0; i<${#PL[@]}; i++));
do
    for ((j=i+1; j<${#PL[@]}; j++));
    do
        echo ${PL[$i]} " vs " ${PL[$j]}
#        echo `expr match "${PL[$i]}" '\(0\.[0-9]*_[0-9]*\)'`
#        echo "vs"
#        echo `expr match "${PL[$j]}" '\(0\.[0-9]*_[0-9]*\)'`
        echo "nonsynonymous"
        python scripts/ranking_common_genes.py ${PL[$i]}nonsyn_union_genes.txt ${PL[$j]}nonsyn_union_genes.txt
#        python scripts/ranking.py <(awk '{print $4}' ${PL[$i]}nonsyn_union_genes.txt) <(awk '{print $4}' ${PL[$j]}nonsyn_union_genes.txt) 

        echo "allbut_synonymous"
        python scripts/ranking_common_genes.py ${PL[$i]}allbutsyn_union_genes.txt ${PL[$j]}allbutsyn_union_genes.txt 
#        python scripts/ranking.py <(awk '{print $4}' ${PL[$i]}allbutsyn_union_genes.txt) <(awk '{print $4}' ${PL[$j]}allbutsyn_union_genes.txt) 

    done
done

