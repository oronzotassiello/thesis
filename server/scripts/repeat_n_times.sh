#!/bin/bash

TCGA_DIR=$1
OTG_DIR=$2
N=$3
OF=$4 #$1

repeat=10

for ((i=0; i<$repeat; i++));
do
    out_syn=${OF}"/syn/"${i}
    out_nonsyn=${OF}"/nonsyn/"${i}
    out_allbutsyn=${OF}"/allbutsyn/"${i}

    mkdir -p $out_syn
    mkdir -p $out_nonsyn
    mkdir -p $out_allbutsyn

    ./scripts/bootstrap_syn.sh $TCGA_DIR $OTG_DIR $N $out_syn
    ./scripts/bootstrap_nonsyn.sh $TCGA_DIR $OTG_DIR $N $out_nonsyn
    ./scripts/bootstrap_allbutsyn.sh $TCGA_DIR $OTG_DIR $N $out_allbutsyn
done 
