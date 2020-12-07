#!/bin/sh
CODEDIR="/projectnb/lau-bumc/SOFTWARE/TIDAL/CODE"
source $CODEDIR/TIDAL_module.sh

GHOME="/projectnb/lau-bumc/gchirn"
RHOME="/projectnb/lau-bumc/reazur"

#usage: ./TE_count_TIDAL.sh libname.fastq.uq.polyn lib.sort.bam

input=$1
prefix=${1%.fastq.uq.polyn*}

#genome_bam=$prefix".sort.bam"
genome_bam=$2
read_count=$(samtools view -c $genome_bam)
#normalized to per million mapped reads
#read_count=1000000

database="/projectnb/lau-bumc/SOFTWARE/TIDAL/TE_count_database/dm_TE_gene"
align_input=$input
$RHOME/CORE/align_to_gene_list_bowtie2.sh $input $database "TE consensus mapping"

#the bed have been created...

#get the read count from number of mapped read to genome
#read_count=$(grep "^>" $align_input".mapped" | cut -d':' -f2 | $GHOME/CORE/bin/sum ) 

#read_count=$(grep -v "track" $align_input".rep.bed" | cut -f4 | cut -d':' -f2 | $GHOME/CORE/bin/sum )

#echo "Done with first part: read count=$read_count"
#----------------------------------------
##(this can be changed to get the count from .rep.bed file)
#echo -n "$1 mapped (from bed file) " >> summary
#grep -v '^track' $1.rep.bed | grep -v '^virus=' | cut -f4 | sort -u | cut -d':' -f2 | $HOME/CORE/bin/sum >> summary
#-----------------


#perl $RHOME/CORE/parse_bedfile_single_strand_specific_include_coordinates.pl -q $align_input -r $read_count -s ~reazur/REFSEQ/fly_refseq_intron.fa > $prefix".gene_table.xls"

TE_fasta="/projectnb/lau-bumc/SOFTWARE/TIDAL/TE_count_database/consensus_TE_gene_fly.fa"
perl $CODEDIR/generate_read_count_TE.pl -q $align_input -r $read_count -s $TE_fasta > $prefix".TE_table.xls"


#combine files from different libraries and merge gene models

#cluster_coverage_file=$prefix"_cluster_coverage_"$buffer"_bp.xls"  
#perl $RHOME/CORE/parse_bedfile_single_read_library.pl -q $input -r $readnum -s $outfile > $cluster_coverage_file
 
  
gzip $input".rep.bed"
rm z*
rm $align_input".rep.sam"
rm $align_input".sam"
#rm summary
