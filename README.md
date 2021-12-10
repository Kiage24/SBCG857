# SBCG857
## Sequencing,sequencing analysis and HPC.

# QC ASSIGNMENT 1

## EXERCISE 1:SAM header line
Look at the following line from the header of the BAM file

Q.What does RG stand for?

 Read group;it indicates the number of reads for a given sample

Q.What is the sequencing platform?

 Illumina

Q.What is the sequencing centre?

 SC

Q.What is the lane ID?

 ERR003612

Q.What is the expected fragment insert size?

 2000

## EXERCISE 2:SAM header and samtools
Use the samtools view command to print the header of the BAM file

```
samtools view -H NA20538.bam | less
```

Q.What version of the human assembly was used to perform the alignments? 
 
 v37  

Q.How many lanes are in this BAM file? 

 15

```
samtools view -H NA20538.bam | grep '^@RG'| wc -l
```
Q.What programs were used to create this BAM file?

 samtools	

Q.What version of bwa was used to align the reads?

 VN:1.0 


## EXERCISE 3:Alignment formats conversion
Use samtools to convert between SAM<->BAM and to view or extract regions of a BAM file

Q.What is the name of the first read? 

 ERR003814.1408899 

Q.What position does the alignment of the read start at?

 163
 
Q.What is the mapping quality of the first read?

 23 

Q.Can you convert the BAM file to a CRAM file called yeast.cram using the samtools view command?

```
samtools view -T Saccharomyces_cerevisiae.EF4.68.dna.toplevel.fa -C yeast.bam -o yeast.cram
```
Q.What is the size of the CRAM file?

18M

```
ls -lh yeast.cram 
```
Q.Is your CRAM file smaller than the original BAM file?

 yes ,

 BAM file ; 34M

 CRAM file ; 18M
 
```
ls -lh yeast.bam
```

## EXERCISE 4:VCF/BCF and bcftools
Use bcftools to convert between VCF<->BCF and to view or extract records from a region

```
bcftools view -h 1kg.bcf | less
```
Q.What version of the human assembly the coordinates refer to?

GRCh37

```
bcftools view -h 1kg.bcf | less
```

Q.Can you convert the file called 1kg.bcf to a compressed VCF file called 1kg.vcf.gz using the bcftools view command?

 No it requires an indexed file

Index the BCF

```
bcftools index 1kg.bcf
```

Extract all records from the region 20:24042765-24043073

```
bcftools view 1kg.bcf region 20:24042765-24043073|less -S
```

The versatile bcftools query command can be used to extract any VCF field;

Q.How many samples are in the BCF?

 50 samples
 
```
bcftools query -l 1kg.bcf | wc -l
```

Q.What is the genotype of the sample HG00107 at the position 20:24019472?

 A/T

```
bcftools query -r 20:24019472 -s HG00107 -f'[%TGT]\n' 1kg.bcf
```

Q.How many positions there are with more than 10 alternate alleles?

```
bcftools query -f'[%AC]\n' -i'AC>10' 1kg.bcf| wc -l
```
4778

Q.List all positions where HG00107 has a non-reference genotype and the read depth is bigger than 10

```
bcftools query -s HG00107 -f'%CHROM %


## Exercise 5:Generate QC stats
Create the mappings

```
./align.sh
```
Generate the stats

```
samtools stats -F SECONDARY lane1.sorted.bam > lane1.sorted.bam.bchk
```
Look at the output and answer the following questions

Q.What is the total number of reads?

 400252

Q.What proportion of the reads were mapped?

 303036

Q.How many reads were mapped to a different chromosome?
 
 2235
 
Q.What is the insert size mean and standard deviation?

 Mean - 275.9
 Standard deviation - 47.7
 
Q.How many reads were paired properly?
 
 282478
 
Create some QC plots from the output of the stats command;

```
plot-bamstats -p lane1-plots/ lane1.sorted.bam.bchk
```
Q.How many reads have zero mapping quality?

 23,803

Q.Which of the first fragments or second fragments are higher base quality on average?
 
 Foward reads

 


