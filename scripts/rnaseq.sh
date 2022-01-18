#!/usr/bin/bash

#Indexing and mapping
#echo 'Indexing and mapping'

ref = .fa
hista2-build ${ref} ${ref}.idx

# create a text file with list of samples.
mkdir ./results

for sample in $(ls *fastq | cut -d _ -f 1):
do
 R1= ${sample}_1.fastq
 R2=${sample}_2.fastq
 hisat2 --max-introlen 10000 -x ${ref}.idx -1 ${R1} -2 ${R2} -S ./results/${sample}.sam
done ; 
