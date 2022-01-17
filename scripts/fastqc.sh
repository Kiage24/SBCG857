#!usr/bin/bash

#Running fastqc on file.

fastqc ../../NGS_Hinxton_data/course_data/Module2_QC/yeast.bam -o ../../Fastqc/results

# Plot statistics

firefox ../../Fastqc/yeast_fastqc.html 
