#!/bin/sh
#runs the TIDAL pipeline
CODEDIR="/nlmusr/reazur/linux/NELSON/TIDAL/CODE"
RHOME="/nlmusr/reazur/linux"

#pass the fastq filename as argument
lib1=$1
lib2=$2
prefix=${1%_R1.fastq*}
read_len=$3

lib=$prefix"_SE.fastq"
cat $lib1 $lib2 > $lib

#
#exit
#data prep and creation of uq file
$CODEDIR/data_prep.sh $lib 
#run the insertion part of TIDAL
$CODEDIR/insert_pipeline.sh $lib".uq.polyn" $read_len  
#set up symbolic links to do the depletion part of TIDAL
$CODEDIR/setup.sh $lib
#run the depletion part of TIDAL
$CODEDIR/depletion_pipeline.sh $lib".uq.polyn" $read_len
#compile insertion and depletion results
$CODEDIR/last_part.sh $lib $CODEDIR