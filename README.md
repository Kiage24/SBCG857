# ALLIGNMENT

## Question 1

What is the length of chromosome 1 of the mouse genome?

195471971

## Index the reference file.

```
bwa index
```
## Align the paired fastq files to the indexed reference file.

```
bwa mem GRCm38.68.dna.toplevel.fa ../Documents/course_data/Module3_ReadAlignment/Exercise2/fastq/md5638a_7_87000000_R1.fastq ../Documents/course_data/Module3_ReadAlignment/Exercise2/fastq/md5638a_7_87000000_R2.fastq
```
## Convert the SAM file to a BAM file

```
samtools view -O BAM md5638-2.sam -o md5638-2.bam
```
## Sort the BAM file.

```
samtools sort -T temp -o md5638-2.sorted.bam md5638-2.bam 
```

## Index the sorted BAM file

```
samtools index md5638-2.sorted.bam
```

## Mark Duplicates using the sorted bam file

```
picard-tools MarkDuplicates I= md5638-2.sorted.bam O= md5638-2.markdup.bam M= md5638-2.metrics.txt
```
## Index the resultant file

```
samtools index md5638-2.markdup.bam
```
## Generate statistics 

```
stats md5638-2.markdup.bam
```
What is the total number of reads?

 392820

What proportion of the reads was mappped?

 391594
 
How many reads were paired correctly/properly?

389366

How many reads mapped to a different chromosone?

37

What is the insert size mean and standard deviation?

418.5,
112.9

## Create QC plots

```
plot-bamstats -p md5639.2_plot md5638-2.markdup.stats 
```

## View plots
 
 ```
 fireox md5639.2_plot.html
 ```
 ## BAM visualization.
 
 ```
 igv
 ```





