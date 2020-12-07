#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Std;



my $input_filename = $ARGV[0];
open(my $INFILE, "<", $input_filename) 
        or die "unable to open ct file $$input_filename";


my $arr2d=[];
my $first_line;
while ( my $line = <$INFILE> ) {
    chomp $line;
    if ($line=~/^Identifier/) {
	$first_line = $line;
	next;
    }

    my @arr = split(/\t/, $line);
#    my $gene_name = $arr[0];
#    print "gene name: $gene_name\n";
    
    push @{$arr2d}, \@arr;

#    my $refsize = @{$ghash->{$gene_name}};  
#   print "num of element: $refsize\n";
    
}


close $INFILE;

my @sortarr = sort { ($a->[2] cmp $b->[2]) || ($a->[3] <=> $b->[3]) } @{$arr2d};

my ($curr, $prev);
 
foreach my $line ( @sortarr ) {


    foreach my $el ( @$line ) {
	print "$el\t";
    }
    print "\n";
        
}
