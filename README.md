# VARIANT CALLING
## Exercise 1:Making sense of the input data

**Generate statistics using samtools**

```
samtools -r ref bam > .stats
samtools stats -r GRCm38_68.19.fa A_J.bam > A_J.stats
 samtools stats -r GRCm38_68.19.fa NZO.bam > NZO.stats
```

**plot graphs**

```
 plot-bamstats -r GRCm38_68.19.fa.gc -p A_J.graphs/ A_J.stats
 plot-bamstats -r GRCm38_68.19.fa.gc -p NZO.graphs/ NZO.stats

```
```
firefox A_J.graphs/index.html
```

```
What is the percentage of mapped reads in both strains? 

A_J - 99.7  , NZO - 99.7

Check the insert size, - A.J 353 NZO - 354
GC content - A.J 50.2 NZO-51.3
per-base sequence content - No significant variation
quality per cycle graphs. - 
Do all look reasonable? yes

## Exercise 2: Generating pileup

What is the read depth at position 10001994? (Rather than scrolling to the position, use the substring searching capabilities of less: press /, then type 10001994 and enter to find the position.)




