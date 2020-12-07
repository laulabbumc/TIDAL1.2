input=$1
output=$2
avgquality="20"

#with log file
#java -jar ~reazur/SOFTWARE/Trimmomatic-0.30/trimmomatic-0.30.jar SE -phred33 -trimlog log.txt $input $output CROP:45 HEADCROP:6 LEADING:25 TRAILING:25 AVGQUAL:$avgquality MINLEN:85

#without log file
java -jar ~reazur/SOFTWARE/Trimmomatic-0.30/trimmomatic-0.30.jar SE -phred33 $input $output LEADING:20 TRAILING:20 AVGQUAL:$avgquality
