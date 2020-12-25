#!/bin/sh

CODEDIR="/projectnb/lau-bumc/SOFTWARE/TIDAL/CODE"

database=$2
text=$3
input=$1

output=$input".sam"

#run bowtie 2
bowtie2 -f --sensitive -p 9 --end-to-end -x  $database -S $output -U $input
samtools view -Sh -q 10 $output > high_quality.sam
mv high_quality.sam $output

cp $output z0.$1


grep '^@' z0.$1 > $1.rep.sam
cat z0.$1 | grep -v '^@' | grep -v '	4	\*	0	0	\*	\*	0	0	' | sort -u >> $1.rep.sam


#echo "Done with first part"

#############################
## make bed file   
#############################
grep    '^@' $1.rep.sam > z5.$1
grep -v '^@' $1.rep.sam | grep '[ACTGN][ACTGN]*:[0-9][0-9]*	0	' >> z5.$1
grep    '^@' $1.rep.sam > z6.$1
grep -v '^@' $1.rep.sam | grep '[ACTGN][ACTGN]*:[0-9][0-9]*	16	' >> z6.$1
samtools view -bS z5.$1 > z7.$1
bamToBed -i z7.$1 > z8.$1
cut -f2,3 z8.$1 | paste z8.$1 - | sed 's/$/	255,0,0/' > z9.$1
samtools view -bS z6.$1 > z7.$1
bamToBed -i z7.$1 > z8.$1

cut -f2,3 z8.$1 | paste z8.$1 - | sed 's/$/	0,0,255/' >> z9.$1
echo "track name=\"$1\" description=\"$1\" visibility=2 itemRgb=\"On\"" > $1.rep.bed
sort -T ./ +0 -1 +1 -2n +2 -3n z9.$1 >> $1.rep.bed
#exit;

echo "Bed files created"


echo -n "$1 mapped TO $database (counted from bed file) " >> summary
grep -v '^track' $1.rep.bed | grep -v '^virus=' | cut -f4 | sort -u | cut -d':' -f2 | $CODEDIR/sum >> summary

cp summary summary.txt

exit


