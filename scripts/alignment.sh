#!/usr/bin/bash

#echo 'Conducting quality check'
file1 = .fastq

fastqc ${file} -o results.
firefox ${file}.html

#echo 'conduct trimming'

sickle pe -f s_7_1.fastq -r s_7_2.fastq -t sanger -o s_7_1_trimmed.fastq -p s_7_2_trimmed.fastq -s s_7_combined.fastq 30 
trimmomatic PE s_7_1.fastq s_7_2.fastq s_7_1-trim.fastq s_7_1-untrim.fastq s_7_2-trim.fastq s_7_2-untrim.fastq TRAILING:20

#echo 'Mapping/alignment'
#echo 'Indexing the reference using bwa'

bwa index .fa

#echo 'Aligning'

bwa mem .fa f/r.fastq > .sam

#echo 'Manipulation of sam file'
#echo 'Converting sam to bam'

samtools view -O BAM md5638.2.sam -o md5638.bam

#echo 'Sorting the bam file'

samtools sort -T temp -O bam -o md5638.sorted.bam md5638.bam

#echo 'Indexing the sorted BAM file'

samtools index md5638_sorted.bam

#echo 'Marking PCR duplicates'

picard MarkDuplicates -I hilda_sorted.bam -M hilda_markdup_metrix.txt -O hilda_markdup.bam

#echo 'Indexing the markdup BAM file'

samtools index hilda_markdup.bam
 
#echo 'Generating QC stats of the aligned BAM file, using the markdup.BAM'

samtools stats md5638.markdup.bam > md5638.markdup.stats

#echo 'Creating some QC plots from the output of the stats command'

plot-bamstats -p md5639_plot md5638.markdup.stats

firefox *.html

#echo 'Opening 
