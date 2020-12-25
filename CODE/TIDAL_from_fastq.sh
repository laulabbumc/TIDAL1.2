#!/bin/sh

#module the necessary modules of software (grid engine specific), not needed in other OS
source /projectnb/lau-bumc/SOFTWARE/TIDAL/github/TIDAL1.2/CODE/TIDAL_module.sh
#runs the TIDAL pipeline
CODEDIR="/projectnb/lau-bumc/SOFTWARE/TIDAL/github/TIDAL1.2/CODE"

#pass the fastq filename as argument
lib=$1
prefix=${1%.fastq*}
#read_len=151
read_len=$2

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
