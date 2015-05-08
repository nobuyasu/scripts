#!/usr/bin/perl

use lib "$ENV{'HOME'}/perllib";

use App::Options(
    values => \%optn,            
    option => {
        pdb => {
            type => 'string',
            required => 1,
        },
	delchid =>{
            type => 'boolean',
	}
    },
);

my %list;
my $ifopen = 0;
my $output = $optn{pdb}; $output =~ s/\.pdb//;
open( INP, "$optn{pdb}" );
while(<INP>){
    if(/^ATOM/){
	$line = $_;
	chomp;
	split;
	my $chid  = substr($_, 21,1);
	if( $optn{delchid} ){
	    substr($line, 21,1) = " ";	    
	}
	
	unless ( defined( $list{$chid} ) ){
	    $list{$chid} = 10; 
	    if( $ifopen == 1 ){
		close( OUT );
	    }
	    my $filename = $output."_".$chid.".pdb";
	    $ifopen = 1;
	    open( OUT, ">$filename" );
	    push( @outfiles, $filename );
	}

	print OUT "$line";
    }
}
close(INP);


foreach my $f ( @outfiles ){
    print "$f was produced.\n";
}
