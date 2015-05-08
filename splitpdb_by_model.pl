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
$model = 0;
open( INP, "$optn{pdb}" );
while(<INP>){

    chomp;
    split;
    $line = $_;

    if( /ENDMDL/ ){
	close( OUT );
    }

    if( /^MODEL/ ){
	$model ++;
	my $filename = $output."_".$model.".pdb";
	open( OUT, ">$filename" );
	push( @outfiles, $filename );
    }

    if(/^ATOM/){
	print OUT "$line\n";
    }

}
close(INP);

foreach my $f ( @outfiles ){
    print "$f was produced.\n";
}
