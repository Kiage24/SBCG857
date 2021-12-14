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


What is the percentage of mapped reads in both strains? 

A_J - 99.7  , NZO - 99.7

Check the insert size, - A.J 353 NZO - 354
GC content - A.J 50.2 NZO-51.3
per-base sequence content - No significant variation
quality per cycle graphs. - 
Do all look reasonable? yes


## Exercise 2: Generating pileup

What is the read depth at position 10001994? (Rather than scrolling to the position, use the substring searching capabilities of less: press /, then type 10001994 and enter to find the position.)

Read DePth - 66

What is the reference base

A

Are there any non-reference bases?

-YES - G- mismatch forward g - mistmatch reverse

## Exercise 3: Generating genotype likelihoods and variant calling

The mpileup command (traditionally in samtools, now moved to bcftools) can be used to generate genotype likelihoods. Try to run the following command (press "q" to quit the viewing mode)
```
bcftools mpileup -f GRCm38_68.19.fa A_J.bam | less -S
```
This generates an intermediate output which contains genotype likelihoods and other raw information necessary for calling. This output is usually streamed directly to the caller like this

```
bcftools mpileup -f GRCm38_68.19.fa A_J.bam | bcftools call -m | less -S
```
This generates an intermediate output which contains genotype likelihoods and other raw information necessary for calling. This output is usually streamed directly to the caller like this

```
bcftools mpileup -f GRCm38_68.19.fa A_J.bam | bcftools call -m | less -S
```
What option should be added to only print out variant sites? Hint: check the program usage by running bcftools call without any parameters.
option -v 

```
bcftools mpileup -f GRCm38_68.19.fa A_J.bam | bcftools call -mv | less -S
```

The INFO and FORMAT fields of each entry tells us something about the data at the position in the genome. It consists of a set of key-value pairs with the tags being explained in the header of the VCF file (see the ##INFO and ##FORMAT lines in the header). Let mpileup output more information. For example we can ask it to add the FORMAT/AD tag which informs about the number of high-quality reads that support alleles listed in REF and ALT columns. The list of all
available tags can be printed with "bcftools mpileup -a?".


Now let's run the variant calling again, this time adding the -a AD option. We will also add the -Ou option to
mpileup so that it streams a binary uncompressed BCF into call. This is to avoid the unnecessary CPU
overhead of formatting the internal binary format into plain text VCF only to be immediately formatted back to
the internal binary format again:

```
bcftools mpileup -a AD -f GRCm38_68.19.fa A_J.bam -Ou | bcftools call -mv -o out.vcf
```

Examine the VCF file output using the unix command less:

```
less -S out.vcf
```

What is the reference and SNP base at position 10001994?

Reference - A
SNP - G

What is the total read depth at position 10001994?

DP=69

What is the number of high-quality reads supporting the SNP call at position 10001994? ?

DP4 = forward - 34, reverse -32

How many reads support the reference allele 

DP = 0

What sort of event is happening at position 10003649?

An INDEL


## Exercise 4: Variant filtering

In the series of commands we will learn how to filter and extract information from VCFs. Most of the bcftools commands accept the -i, --include and -e, --exclude options (documentation) which will come handy when filtering using fixed thresholds. We will estimate the quality of the callset by calculating the transition/transversion ratio.

In order to verify that the filtering expression has the desired effect, it is useful to first run a few small tests. Let's start with printing a simple list of positions from the VCF using the bcftools query command (manual) and pipe through the head command to trim the output after a few lines:

```
bcftools query -f'POS = %POS\n' out.vcf | head
```
The formatting expression "POS = %POS\n" was expanded for each line in the VCF and consisted of the string
"POS = ", which was printed on the output unchanged, the string with a special meaning " %POS", which was
replaced by the POS column for each line, and the new line character "\n", which put the new line character
after each VCF record. (If it were not present, the positions from the entire VCF would be printed on a single
line.)

Now add REF and ALT allele to the output, separated by a comma

```
bcftools query -f'%POS %REF,%ALT\n' out.vcf | head
```
In the next step add also the quality, genotype and sequencing depth to the output. For the depth, check the AD
annotation, which gives the number of reads observed for each reference and alternate alleles. For example, if
there were 3 reads with the reference allele and 5 reads with the alternate allele, the AD field would be AD=3,5.
Note that the FORMAT fields must be enclosed within square brackets "[]" to iterate over all samples in the
VCF. (Check the "Extracting per-sample tags" section in this short tutorial for an explanation why the square
brackets are needed.)

```
bcftools query -f'%POS %QUAL [%GT %AD] %REF %ALT\n' out.vcf | head
```

Now filter rows with quality smaller than 30 and exclude indels. 

```
bcftools query -f'%POS %QUAL [%GT %AD] %REF %ALT\n' -i'QUAL>=30 && type="snp"' out.vcf | head
```
Check the record at the position 10000143, is it still present in the output?

No

Can you print rows with QUAL bigger than 30 and with at least 25 alternate reads? 

For this we will  need to query the second value of the AD field. Note that the indexes are zero-based; the first AD value is represented as "AD[0]", therefore the second value must be queried as "AD[1] >= 25".

```

bcftools query -f'%POS %QUAL [%GT %AD] %REF %ALT\n' -i'QUAL>=30 && AD[0:1]>=25 ' out.vcf | head
```

Finally, use the following command to obtain the ts/tv of unfiltered callset.

   bcftools stats out.vcf | grep TSTV | cut -f5

       Q: How the ts/tv changes if you apply the filters above? Use the bcftools stats command with the -i
       option to include calls with QUAL at least 30 and the number of alternate reads at least 25.


       Q: What is the ts/tv of removed sites?
^L       Q: The test data come from inbred homozygous mouse, therefore any heterozygous genotypes are
       most likely mapping and alignment artefacts. Can you find out what is the ts/tv of heterozyous SNPs?
       Use bcftools view -i 'GT="het"' to select or bcftools view -e 'GT="het"' to exclude sites with
       heterozygous genotypes.


Another useful command is filter which allows to annotate the VCF file soft filters based on the given
expression, rather than removing the sites completely. Can you apply the above filters to produce a final callset
and apply the -g and -G options to soft filter variants around indels?
bcftools filter -sLowQual -m+ -i'QUAL>=30 && AD[1]>=25' -g8 -G10 out.vcf -o out.flt.vcf









