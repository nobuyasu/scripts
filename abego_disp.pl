#!/usr/bin/perl

sub get_color {

    my ( $abego ) = @_;

    my $color;
    if ( $abego eq "A" ) {
	$color = "tvred";
    } elsif ( $abego eq "B" ) {
	$color = "skyblue";
    } elsif ( $abego eq "G" ) {
	$color = "splitpea";
    } elsif ( $abego eq "E" ) {
	$color = "brightorange";
#	$color = "orange";
    } elsif ( $abego eq "O" ) {
	$color = "gray40";
    }

    return $color;

}


$PWD = `pwd`; chomp $PWD;

use lib "$ENV{'HOME'}/perllib/";
use DRAW_PYMOLCGO;
use PDB;

use App::Options(
    values => \%optn,
    option => {
        pdb => {
            type => 'string',
            required => 1,
            description => 'pdb file',
        },	       
        rama => {
            type => 'string',
            required => 1,
            description => 'rama file',
        },
	out => {
	    type => 'string',
	    default => 'abego.pml',
	},
	wo_cbeta => { 
	    type => 'boolean',
	    default => 0,
	},
	helix_lego => { 
	    type => 'boolean',
	    default => 0,
	},
	strand_lego => { 
	    type => 'boolean',
	    default => 0,
	},
	thin_cartoon => { 
	    type => 'boolean',
	    default => 0,
	},
    }
    );


my @ss, @abego;
open( RAMA, "$optn{rama}" ) || die ( "cannot open $optn{rama}\n" );
while ( my $line = <RAMA> ) {

    next if( $line =~ m/^\#/ );
    chomp $line;
    my @dat = split( /[\s\t\n=]+/, $line );
    my $ss    = $dat[3];
    my $abego = $dat[4];

    $ss[$dat[1]-1] = $dat[3];
    $abego[$dat[1]-1] = $dat[4];

#    print "$dat[1] $dat[2] $ss $abego\n";
}
close( RAMA );


my $pdb  = PDB->new;
my $pose = $pdb->getCoord( $optn{pdb} );

my $pymol=DRAW_PYMOLCGO->new;
$pymol->open_file( $optn{out} );
$pymol->set_colors;
$pymol->load_pdb( $optn{pdb}, \@ss );
if( $optn{thin_cartoon} ) {
    $pymol->set_cartoon;
}

for ( my $ii=0; $ii<$pdb->{total_residue}-2; ++$ii ) {

    my $n = $ii+1;

    my $ca1 = $pdb->{pose_ca}[$n-1];
    my $ca2 = $pdb->{pose_ca}[$n];
    my $ca3 = $pdb->{pose_ca}[$n+1];

    my $cb2 = $pdb->{pose_cb}[$n];

    my $color = &get_color( $abego[ $n ] );
    my @triple_ca = ( $ca1, $ca2, $ca3 );

#	print "$n $ss[ $n ] $ca2->{rname} \n";

    my $next_ss = $ss[ ${n}+1 ];

    ##################
#    $pymol->draw_residue_normal( $n+1, \@triple_ca, $cb2, $color, 6 );
#    next;
    #####################

    if( $ss[ $n ] eq "L" ) {
#	$color = "gray60";
    }

    ## out 
    if ( $next_ss ne $ss[ $n ] && $n != $pdb->{total_residue} - 1 && $next_ss eq "L"  ) {

	if( $ss[ $n ] eq "H" ) {
	    $type = 3; 
        } else {
	    if( $optn{strand_lego} ) {
		$type = 8;
	    } else {
		$type = 3;
	    }
	}

	$pymol->draw_residue_normal( $n+1, \@triple_ca, $cb2, $color, $optn{wo_cbeta}, $type );
	$old_ss  = $ss[ $n ];
	next;
    }

    ## in
    if ( $old_ss ne $ss[ $n ] && $old_ss eq "L" ) {
	if( $ss[ $n ] eq "E" ) {
	    if( $optn{strand_lego} ) {
		$type = 8; 
	    } else {
		$type = 2;
	    }
        } else {
	    $type = 2;
	}

	$pymol->draw_residue_normal( $n+1, \@triple_ca, $cb2, $color, $optn{wo_cbeta}, $type );
	$old_ss  = $ss[ $n ];
	next;
    } 

    $type = 0;
    if ( $ss[ $n ] eq "L" ) {
	$type = 8;
    } elsif ( $ss[ $n ] eq "E" ) {
	if( $optn{strand_lego} ) {
	    $type = 8;
	}
    } elsif ( $ss[ $n ] eq "H" ) {
	if( $optn{helix_lego} ) {
	    $type = 8;
	}
    }

    $pymol->draw_residue_normal( $n+1, \@triple_ca, $cb2, $color, $optn{wo_cbeta}, $type );
    $old_ss  = $ss[ $n ];
    
}

$pymol->add_end;













