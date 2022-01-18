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
 fastqc ${R1} ${R2}
 hisat2 --max-introlen 10000 -x ${ref}.idx -1 ${R1} -2 ${R2} -S ./results/${sample}.sam
 

 #Convert the file to bam
 #echo 'Converting sam to bam and generating indexed files'
 
 samtools view -O bam ${sample}.sam -o ${sample}.bam
 samtools sort -O BAM ${sample}.bam -o ${sample}_sorted
 samtools index ${sample}_sorted
 
 #Quantification
 #echo 'Indexing and quantification'
 ref = transcript.fa
 kallisto index ${ref} -i ${ref}.idx
 kallisto quant -i ${ref}.idx -o ${sample} -b 100 ${R1} ${R2} 
 
