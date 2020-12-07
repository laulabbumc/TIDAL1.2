#!/bin/sh
prefix=${1%.fastq.uq*}
samfile=$1

samtools view -@ 4 -Sh -q 10 $samfile > test.sam
mv test.sam $samfile
samtools view -@ 4 -bSh $samfile > $prefix".bam"
samtools sort -@ 4 $prefix".bam" -o $prefix".sort.bam"
samtools index $prefix".sort.bam"
#samtools view -h $prefix".sort.bam" >  $prefix".sort.sam"

rm $prefix".bam" 
rm $samfile
