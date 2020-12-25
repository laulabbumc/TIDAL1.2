#!/bin/sh
CODEDIR="/projectnb/lau-bumc/SOFTWARE/TIDAL/github/TIDAL1.2/CODE"
source /projectnb/lau-bumc/SOFTWARE/TIDAL/CODE/TIDAL_module.sh

#usage: ./TE_coverage_TIDAL.sh libname.fastq.uq.polyn lib.sort.bam

input=$1
prefix=${1%.fastq.uq.polyn*}
database="/projectnb/lau-bumc/SOFTWARE/TIDAL/TE_count_database/dm_TE_gene"
TE_fasta="/projectnb/lau-bumc/SOFTWARE/TIDAL/TE_count_database/consensus_TE_gene_fly.fa"

#genome_bam=$prefix".sort.bam"
genome_bam=$2
read_count=$(samtools view -c $genome_bam)
#normalized to per million mapped reads
#read_count=1000000

#database="/projectnb/lau-bumc/SOFTWARE/TIDAL/TE_count_database/dm_TE_gene"
align_input=$input
$CODEDIR/align_to_gene_list_bowtie2.sh $input $database "TE consensus mapping"

#the bed have been created...


#TE_fasta="/projectnb/lau-bumc/SOFTWARE/TIDAL/TE_count_database/consensus_TE_gene_fly.fa"
perl $CODEDIR/generate_read_count_TE.pl -q $align_input -r $read_count -s $TE_fasta > $prefix".TE_table.xls"


  
gzip $input".rep.bed"
rm z*
rm $align_input".rep.sam"
rm $align_input".sam"
#rm summary
