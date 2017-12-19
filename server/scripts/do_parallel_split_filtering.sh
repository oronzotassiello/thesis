#!/bin/bash

./vcf-parsing/otg/split_filtering_freq_pz.sh data/1kgenomes/input/chr_list_noY.in data/1kgenomes/input/pz_list_pt1.in vcf-parsing/otg/main_vcfnnvrprsr_otg.py myout/otg/05/from_pz/ &

./vcf-parsing/otg/split_filtering_freq_pz.sh data/1kgenomes/input/chr_list_noY.in data/1kgenomes/input/pz_list_pt2.in vcf-parsing/otg/main_vcfnnvrprsr_otg.py myout/otg/05/from_pz/ &

./vcf-parsing/otg/split_filtering_freq_pz.sh data/1kgenomes/input/chr_list_noY.in data/1kgenomes/input/pz_list_pt3.in vcf-parsing/otg/main_vcfnnvrprsr_otg.py myout/otg/05/from_pz/ &
