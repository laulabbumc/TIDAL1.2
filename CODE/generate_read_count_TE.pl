#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Std;

my %option;
getopts( 'q:r:s:h', \%option );

my ($query, $readnum, $seq_db_file);

if ( ( $option{q} ) && ($option{r}) && ($option{s}) ) {
    $query = $option{q};
    $readnum = $option{r};
    $seq_db_file = $option{s};
} else {
    die "Proper parameters no passed";
} 

my $query_filename  = $query.".rep.bed";
#filenames are harded coded here, but they can passed from command line
#my @filearr = qw/Het_Asb1_k$readnumidney_AO34.rep.bed KO_Asb1_kideny_AO36.rep.bed HET_Asb1_Testes_AO31.rep.bed KO_Asb1_Testes_AO33.rep.bed HET_Asb1_testes_AO34.rep.bed KO_Asb1_testes_AO36.rep.bed/;

my @filearr = ($query_filename);
$readnum=$readnum/1000000;
my $rpm_hash = { "$query" =>$readnum };

print STDERR "$query => $readnum\n";
#my $rpm_hash = { "SRR609664.nostrna" => 64.126190 };




my $gene_count_hash = {};
my $unified_hash = {}; #build the unified gene list

foreach my $filename (@filearr) {
    my ($gene_hash_pos, $gene_hash_neg, $unified_hash) = &produceGeneCount($filename, $unified_hash);
    $gene_count_hash->{$filename} = [$gene_hash_pos, $gene_hash_neg];

#    my $keylist = keys %{$gene_count_hash->{$filename}};
#    print "Filename: $filename| count: $keylist\n";

}

#build the unified gene list
#my $keylist = keys %$unified_hash;
#print "Unified count: $keylist\n";


#Now build the elements of for contrated_list just the key list
#my $test = 0;
my $len_hash = {};
my $name_hash = {};
foreach my $key (keys %$unified_hash) {
    my $string = $key;   
#    my @arr1 = split(/@/, $key);
#    my $gene_name = $key; #$arr1[0];
    my @arr2 = split(/=/, $key);
    my $gene_name = $arr2[0];   

    if (@arr2 > 2) {
	die "invalid characters like =\n";
    }
#add code to correct the length issue with two entries

    my $new_gene_length = $arr2[1];
    my @tmp = split(/-/, $new_gene_length);
    if ($tmp[1]) {
	$new_gene_length=$tmp[1];
    }
    if (exists $name_hash->{$gene_name}) {
	my $curr_len = $len_hash->{$gene_name};
	if ($curr_len < $new_gene_length) {
	    $name_hash->{$gene_name} = $string;
	    $len_hash->{$gene_name} = $new_gene_length;	
	}
    } else {
	$name_hash->{$gene_name} = $string;
	$len_hash->{$gene_name} = $new_gene_length;	
    }  
    
}

#----------------- need to this portion for entries that are not present in the rep.bed file
#now open the sequence file, and update the missing entries
#$seq_db_file
 open(my $SEQ, "<", $seq_db_file) 
	or die "unable to open file  $seq_db_file";

while ( my $line = <$SEQ> ) {
    chomp  $line;
    
    if ($line=~/^>/) {
	my $foo = reverse($line);
	chop($foo);
	my $first_part = reverse($foo);
	my @arr1 = split(/:/, $first_part);
#remove extra space or comments
	my @tmp1 = split(/ /, $arr1[0]);
#	print STDERR "|$tmp1[0]|\n";
#	die;
	my @arr = split(/=/, $tmp1[0]);
	my $gene_name = $arr[0];
	my $new_gene_length = $arr[1];
	next if ( (exists $name_hash->{$gene_name}) && (exists $len_hash->{$gene_name}) );
	$name_hash->{$gene_name} = $gene_name;
	$len_hash->{$gene_name} = $new_gene_length;
	
    }
}
#------------------------------------        
#die;


#---------------produce head for output-------------------------------
#print "Gene\tLength\tchr:coord\tstrand";
print "Gene\tLength";
foreach my $filename (@filearr) {
    if ($filename=~/(.*)\.fastq.uq.polyn.rep.bed/) {
#   if ($filename=~/(.*)\.rep.bed/) {
#	print "\t'+ $1 read\t'+ $1_RPM\t'- $1 read\t'- $1_RPM";
#	print "\tsense $1 read\tsense $1_RPM\tanti-sense $1 read\tanti-sense $1_RPM";
	print "\t$1_RPM";
    }
}
print "\n";
###############################

#foreach my $key (sort { $a<=>$b } keys %$name_hash) {
foreach my $key (sort keys %$name_hash) {
    my $gene = $key;
    my $len = $len_hash->{$key};
    my $uqstring = $name_hash->{$key};
    if (!(defined $len)) {
#	print STDERR "|||$gene|||\n";
	next;
    }

#----------------------  
    my ($gene_name, $identifier, $chr, $start, $end, $strand) =  split(/@/, $gene);
#    my $gene_identifier = $gene_name.'@'.$identifier;
#    my $chr_coord = $chr.':'.$start.'-'.$end;
##    print STDERR "\ngene_identifier: $gene_identifier\nchr_coord: $chr_coord\n";
##    die;
##    print "$gene\t$len"; #all the new stuf should be extracted and written here
#    print "$gene_identifier\t$len\t$chr_coord\t$strand";
#-----------------------------

#    print STDERR "$gene\t$len";
#    die;
    print "$gene\t$len";

    #add new headers as well..
    foreach my $filename (@filearr) {
	my $filekey;
	if ($filename=~/(.*)\.rep.bed/) {
	  #  print "\t$1";
	    $filekey = $1;
	}

	my $hash_ref = $gene_count_hash->{$filename};
	my ($pos_hash, $neg_hash) = @$hash_ref;
#	if ($strand eq '+') {


	my ($pos_raw_read, $neg_raw_read) = (0, 0);
	if ( exists $pos_hash->{$uqstring} ) {
	    $pos_raw_read = $pos_hash->{$uqstring};
	}
	if ( exists $neg_hash->{$uqstring} ) {
	    $neg_raw_read = $neg_hash->{$uqstring};
	}
	my $total_reads = $pos_raw_read + $neg_raw_read;
	if ($total_reads > 0 ) {
	    my $rpm_reads = $total_reads/$rpm_hash->{$filekey};
	    $rpm_reads = sprintf("%.2f", $rpm_reads);
	    print "\t$rpm_reads";
	} else {
	    print "\t0";
	}
#-------------------------
#	if ( exists $pos_hash->{$uqstring} ) {
#	    my $pos_raw_read = $pos_hash->{$uqstring};
#	    my $rpm_read = $pos_raw_read/$rpm_hash->{$filekey};
#	    $rpm_read = sprintf("%.2f", $rpm_read);
#	    print "\t$pos_raw_read\t$rpm_read";
#	    
#	} else {
#	    print "\t0\t0";
#	}
#	
#	if ( exists $neg_hash->{$uqstring} ) {
#	    my $neg_raw_read = $neg_hash->{$uqstring};
#	    my $rpm_read = $neg_raw_read/$rpm_hash->{$filekey};
#	    $rpm_read = sprintf("%.2f", $rpm_read);
#	    print "\t$neg_raw_read\t$rpm_read";
#	} else {
#	    print "\t0\t0";
#	}
#--------------------------
    }
    print "\n";
    
}





#----------------------------------------------
#then build another hash with gene name as key and gene isoform as value 


exit;

sub produceGeneCount {
    
    my ($filename, $unified_hash) = @_;
    #  my $gene_count = {};
    my $gene_count_pos = {};
    my $gene_count_neg = {};
    my $weight_hash = {}; 

   open(my $FILE, "<", $filename) 
	or die "unable to open file $filename";
    while ( my $line = <$FILE> ) {
	next if ($line=~/^track/);
	
	chomp $line;
	my @arr = split(/\t/, $line);
	my $refgene = $arr[0];
	my $read_target = $arr[3];    
#	my ($read, $count) =  split(/:/, $read_target);
#	my $strand = $arr[5];
	$weight_hash->{$read_target}++;
    }
    close $FILE;
    

    open(my $INFILE, "<", $filename) 
	or die "unable to open file $filename";
    
    while ( my $line = <$INFILE> ) {
	next if ($line=~/^track/);
	
	chomp $line;
	my @arr = split(/\t/, $line);

	#    foreach my $num (@arr) {
	#	
	#	print "$num\n";
	#	
	#    }
	
	my $refgene = $arr[0];
	my $read_target = $arr[3];    
	my ($read, $count) =  split(/:/, $read_target);
	my $strand = $arr[5];
	my $weight=$weight_hash->{$read_target};

#	next if ($strand eq "-"); #only used for mRNA expression library
#	print "refgene: $refgene; read: $read; count: $count; strand: $strand\n";

	if ( $strand eq "+" ) {

	    if (exists $gene_count_pos->{$refgene}) {
		$gene_count_pos->{$refgene} = $gene_count_pos->{$refgene} + ($count/$weight);
	    } else {
		$gene_count_pos->{$refgene} = ($count/$weight);
	    }
	} elsif ( $strand eq "-" ) {
	    
	    if (exists $gene_count_neg->{$refgene}) {
		$gene_count_neg->{$refgene} = $gene_count_neg->{$refgene} +  ($count/$weight);
	    } else {
		$gene_count_neg->{$refgene} =  ($count/$weight);
	    }
	    
	}
	
	$unified_hash->{$refgene}++;
	
    }
    close $INFILE;
    
    return ($gene_count_pos, $gene_count_neg, $unified_hash);    
}
