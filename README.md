# SBCG857
Sequencing,sequencing analysis and HPC.

# QC ASSIGNMENT 1
## EXERCISE 1
1. What does RG stand for?

Read group;it indicates the number of reads for a given sample

2. What is the sequencing platform?

Illumina

3. What is the sequencing centre?

SC

4. What is the lane ID?

ERR003612

5. What is the expected fragment insert size?

2000

## EXERCISE 2
1. What version of the human assembly was used to perform the alignments? 

NCBI37  

2. How many lanes are in this BAM file? 

15

```
samtools view -H NA20538.bam | grep '^@RG'| wc -l
```
3. What programs were used to create this BAM file?

samtools	

4.What version of bwa was used to align the reads?

VN:1.0 


## EXERCISE 3
1. What is the name of the first read? 

ERR003814.1408899 

2. What position does the alignment of the read start at?

3. What is the mapping quality of the first read?

23 

4. Can you convert the BAM file to a CRAM file called yeast.cram using the samtools view command?
```
samtools view -T Saccharomyces_cerevisiae.EF4.68.dna.toplevel.fa -C yeast.bam -o yeast.cram
```
5. What is the size of the CRAM file?

18M 
```
ls -lh yeast.cram 
```
6. Is your CRAM file smaller than the original BAM file?

yes ,

BAM file ; 34M

CRAM file ; 18M
```
ls -lh yeast.bam
```
## EXERCISE 4
1. What version of the human assembly the coordinates refer to?

```
bcftools view -h 1kg.bcf | less
```

VCFv4.1

2.Can you convert the file called 1kg.bcf to a compressed VCF file called 1kg.vcf.gz using the bcftools view command?

No it requires an indexed file

3. Index the BCF

```
bcftools index 1kg.bcf
```
4. Extract all records from the region 20:24042765-24043073








