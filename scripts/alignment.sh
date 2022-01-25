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

#echo'Merging PCR duplicates'
picard-tools MergeSamFiles
 
#echo 'Marking PCR duplicates'

picard MarkDuplicates -I hilda_sorted.bam -M hilda_markdup_metrix.txt -O hilda_markdup.bam

#echo 'Indexing the markdup BAM file'

samtools index hilda_markdup.bam
 
#echo 'Generating QC stats of the aligned BAM file, using the markdup.BAM'

samtools stats md5638.markdup.bam > md5638.markdup.stats

#echo 'Creating some QC plots from the output of the stats command'

plot-bamstats -p md5639_plot md5638.markdup.stats

firefox *.html

#echo 'Opening  igv'

igv
#echo 'generate plots'

samtools stats -r ref bam>stats
plot bamstats -r ref  -p graphs/index.html
firefox index.html

#echo 'read each bases aligned to reference'

samtools mpileup -f GRCm38_68.19.fa A_J.bam | less -S
bcftools mpileup -f GRCm38_68.19.fa A_J.bam | less -S
 #chr,pos,refbase,readdepth,read bases(./,match)(acgtn/mismatch),base quals(^,start,$end,* end).

#echo 'generating genotype likelihoods and calling variants'

bcftools mpileup -f GRCm38_68.19.fa A_J.bam | bcftools call -m | less -S

#echo 'addition of tags'

bcftools mpileup -a?


#echo'variant filtering'

bcftools query -f'POS = %POS\n' out.vcf | head

#echo'obtaining ts/tv ratio'

bcftools stats out.vcf | grep TSTV | cut -f5

#echo 'filter'

bcftools filter -sLowQual -m+ -i'QUAL>=30 && AD[1]>=25' -g8 -G10 out.vcf -o out.flt.vcf

#echo'normalization'

bcftools norm

#echo 'multisample variant calling'


#echo'annotate'

bcftools csq -i 'FILTER="PASS"' -p m -f GRCm38_68.19.fa -g Mus_musculus.part.gff3.gz multi.filt.bcf -o multi.

#echo 'visualise'
 
igv
