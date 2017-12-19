#!/bin/bash

DB_DIR=$1
MUT_FILE=$2
OF=$3

# extracting mutations in mut_file from db_dir 
for f in $(ls "$DB_DIR"*.out.gz);
do
    awk 'NR==FNR{a[$1$2$3$4];next}{if($1$2$4$5 in a) print $0}' $MUT_FILE <(zcat $f) | gzip > ${OF}/$(basename $f)
done
