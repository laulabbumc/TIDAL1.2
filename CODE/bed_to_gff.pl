#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Std;


my $filename= $ARGV[0];

open(my $INFILE, "<", $filename) 
    or die "unable to open file $filename";

my $count=1;
while ( my $line = <$INFILE> ) {
    
    chomp $line;
    my @arr = split(/\t/, $line);
    my $chr=$arr[0];    
    my $start=$arr[1];
    if ($start==0) {
	$start=1;
    }

    my $end=$arr[2];
    my $name="peak_".$count;

    $count++;
#score, strand, frame
    next if ($chr=~/Het/);
    print "$chr\tunknown\texon\t$start\t$end\t.\t.\t.\tgene_id \"$name\"\n";

#    my $text=$arr[8];
#    print "$text\n";
#    my @arr1 = split(/;/, $text);
#    my @arr2 = split(/ /, $arr1[0]);
#    my $gene_name = pop @arr2;
#    $gene_name=~s/"//g;  #"  
#    $gene_count->{$gene_name}++;
# print "gene: $gene_name\n";
    
    }
close $INFILE;

exit;
