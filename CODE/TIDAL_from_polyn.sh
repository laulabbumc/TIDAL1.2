#!/bin/sh

source /projectnb/lau-bumc/SOFTWARE/TIDAL/CODE/TIDAL_module.sh
#runs the TIDAL pipeline
#CODEDIR="/nlmusr/reazur/linux/NELSON/TIDAL/CODE"
CODEDIR="/projectnb/lau-bumc/SOFTWARE/TIDAL/CODE"
#pass the fastq filename as argument
lib=$1
prefix=${1%.fastq.uq.polyn*}
fastq_file=${1%.uq.polyn*}
#read_len=151
read_len=$2

#data prep and creation of uq file
#$CODEDIR/data_prep.sh $lib 
polyn_output=$lib


workdir=$(pwd)
mkdir $workdir"/insertion"
mkdir $workdir"/depletion"


source=$workdir"/"$polyn_output
target=$workdir"/insertion/"$polyn_output
ln -s $source $target


source=$workdir"/"$polyn_output
target=$workdir"/depletion/"$polyn_output
ln -s $source $target




#run the insertion part of TIDAL
$CODEDIR/insert_pipeline.sh $polyn_output $read_len  

#set up symbolic links to do the depletion part of TIDAL
$CODEDIR/setup.sh $fastq_file
#run the depletion part of TIDAL
$CODEDIR/depletion_pipeline.sh $polyn_output $read_len
#compile insertion and depletion results
$CODEDIR/last_part.sh $fastq_file $CODEDIR