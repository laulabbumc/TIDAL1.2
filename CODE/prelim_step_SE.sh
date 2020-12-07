RHOME="/nlmusr/reazur/linux"

prefix=${1%.fastq*}

$RHOME/CORE/ngs_SE_quality_check.sh $1

#then I look into producing the uq file, trimming parameter needs to fixed before I can choose the uqfile
exit

