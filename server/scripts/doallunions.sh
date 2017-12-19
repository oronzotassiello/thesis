#!/bin/bash

p1="myout/0.005_10/" 
p2="myout/0.005_5/"
p3="myout/0.05_10/"
p4="myout/0.05_5/"
p5="myout/0.01_10/"
p6="myout/0.01_5/"
./vcf-parsing/genes_uninon.py ${p1}somatic_genes.txt ${p1}germline_genes.txt | sort -nrk 2 > ${p1}union_genes.txt
./vcf-parsing/genes_uninon.py ${p2}somatic_genes.txt ${p2}germline_genes.txt | sort -nrk 2 > ${p2}union_genes.txt
./vcf-parsing/genes_uninon.py ${p3}somatic_genes.txt ${p3}germline_genes.txt | sort -nrk 2 > ${p3}union_genes.txt
./vcf-parsing/genes_uninon.py ${p4}somatic_genes.txt ${p4}germline_genes.txt | sort -nrk 2 > ${p4}union_genes.txt
./vcf-parsing/genes_uninon.py ${p5}somatic_genes.txt ${p5}germline_genes.txt | sort -nrk 2 > ${p5}union_genes.txt
./vcf-parsing/genes_uninon.py ${p6}somatic_genes.txt ${p6}germline_genes.txt | sort -nrk 2 > ${p6}union_genes.txt
