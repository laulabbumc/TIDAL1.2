RHOME="/nlmusr/reazur/linux"

prefix=${1%.fastq*}
PElib=$1
SElib=$prefix".SE.fastq"

# -l : this is the split length. The concatenated read is split based on this value
# -s is the stop length,the total size of reads before split has to be larger than this value 
perl $RHOME/NELSON/Genome_resequence/split_fastq_file.pl -l 125 -s 150 $PElib > $SElib

$RHOME/CORE/ngs_SE_quality_check.sh $SElib

gzip $PElib
#then I look into producing the uq file, trimming parameter needs to fixed before I can choose the uqfile
exit

