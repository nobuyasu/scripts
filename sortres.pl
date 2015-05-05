#!/usr/bin/perl

@chain = ('A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X');

$i = -1;
while(<>) { # pdb file 
	if(!/^ATOM/) {
		print;
		next;
	}

	$alt = substr($_, 16,1);
	next if($alt ne ' ' and $alt ne 'A'); 
	
	$aname = substr($_, 12,4);
	$hyd = substr($aname, 1, 1);
	next if($hyd eq 'H' or $hyd eq 'D');
	$rname = substr($_, 17,3);
	$chid  = substr($_, 21,1);
	$rser  = substr($_, 22,4);
	$ins   = substr($_, 26,1);
	$xcord = substr($_, 30,8);
	$ycord = substr($_, 38,8);
	$zcord = substr($_, 46,8);
	$occu  = substr($_, 54,6);
	$temp  = substr($_, 60,6);
	$rest  = "    ";

#	if($chid ne $nowchid ){
#	    $nowchid = $chid;
#	    $RSER = 0;
#
#	    $i ++;
#	    $ch = $chain[$i];
#	}


	$RSER++ if($rser ne $rser_prev);
	printf "ATOM  %5d %4s %3s %1s%4d    %8.3f%8.3f%8.3f%6.2f%6.2f%s\n",
			++$ano, $aname, $rname, $ch, $RSER, $xcord, $ycord, $zcord,
			$occu, $temp, $rest;

	$rser_prev = $rser;
}
