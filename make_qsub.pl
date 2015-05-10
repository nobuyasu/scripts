#!/usr/bin/perl

use lib "$ENV{'HOME'}/perllib";
$PWD = `pwd`; chomp $PWD;

################################################################################################
use App::Options(
    values => \%optn,            
    option => {
        list => {
            type => 'string',
            required => 1,
        },
        dir => {
            type => 'string',
	    default => 'jobs',
        },
        njobs => {
            type => 'integer',
	    default => 1,
        },
    },
);


$jdir = $PWD."/$optn{dir}";
if( !-d $jdir ) {
    system( "mkdir ${jdir}" );
}

my $i = 0;
open( ALL, ">$jdir/submit.sh" );
open( INP, $optn{list} ) || die( "cannot open $optn{list}\n" );
while( <INP> ) {

    next if( /^\s*$/ );

    for( $ii=1; $ii<=$optn{njobs}; $ii++ ) { 

	my $line = $_;

	$i++;

	$qsub = "${jdir}/q${i}.sh";
	open( OUT, ">$qsub" );
	print OUT "#!/bin/bash\n";
	$line =~ s/HERE/${PWD}/g;
	$line =~ s/NUM/${ii}/g;
	print OUT "$line";
	close( OUT );

	print ALL "qsub -o $jdir -e $jdir $qsub\n";

    }



}
close( INP );
close( ALL );

system( "chmod +x $jdir/submit.sh" );
