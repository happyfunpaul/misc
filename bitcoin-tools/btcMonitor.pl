#!/usr/local/bin/perl -w 

use strict;
use JSON::Parse 'parse_json';


my $bitMinterAPIKey = "GETYOUROWN";
my $bitMinterURL = "https://bitminter.com/api/users/SOMEUSER";

my $pollInterval = 300;
my $blinkRaw = "/usr/local/bin/blink1raw";
my $blinkDev = "/dev/hidraw*";
my $debug = 1;

######## COLORS #########################################
# These strings are the 'magic' that causes the blink 
# device to display the named colors/patterns.
#########################################################
my $red = '=255,0,0,100';
my $yellow = '=255,96,0,100';
my $green = '=0,255,0,100';
my $flash_red = '@1:255,0,0,100 @2:0,0,0,50 +1';
my $flash_yellow = '@1:255,96,0,100 @2:0,0,0,50 +1';
my $flash_green = '@1:0,255,0,100 @2:0,0,0,50 +1';

sub getBMHashRate {
	my $apikey = shift(@_);
	my $url = shift(@_);
	#TODO: Use LWP instead of curl
	# Use IPv4 only for now, as IPv6 is not listening.
	my $out = `curl -s -4 -H "Authorization: key=$apikey" $url`;
	my $json_ref;
	eval {
		$json_ref = parse_json($out);	
	};
	if ($@ || ! $json_ref) {
		return 0;
	}
	my %json_hash = %$json_ref;
	return $json_hash{hash_rate};

}

sub getNumConns {
	#TODO: Get this more efficiently. Parse /proc/net/tcp maybe? 
	my $numConns = `netstat -tn | grep :8333 | grep ESTAB | wc -l`;
	chomp($numConns);
	return $numConns;
}

sub hashrateToColor {
	my $rate = shift(@_);
	die ("Got invalid value for hash rate.") unless ($rate >= 0);

	if ($rate == 0) {
		return $flash_red;
	} elsif ($rate < 95000) {
		return $flash_yellow;
	} elsif ($rate < 145000) {
		return $green;
	} else {
		return $flash_green;
	}
}

sub connsToColor {
	my $conns = shift(@_);
	die ("Got invalid value for connection count.") unless ($conns >= 0);

	if ($conns == 0) {
		return $flash_red;
	}
	elsif ($conns < 8) {
		return $red;
	}
	elsif ($conns == 8) {
		return $flash_yellow;
	}
	elsif ($conns < 12 ) {
		return $yellow;
	}
	elsif ($conns < 30 ) {
		return $flash_green;
	}
	else {
		return $green;
	}

}

sub callBlinkRaw {

	# Usage: blinkraw {arg, ...}
	#  /dev/whatever  -- open device
	#  ./whatever     -- open device
	#  =R,G,B,t       -- fade to color
	#  :R,G,B         -- set color (now)
	#  @step:R,G,B,t  -- set step
	#  +step          -- start playing at step
	#  -[step]        -- stop playing at step (default zero)
	#  %              -- clear all steps
	#  _              -- turn off
	#  _t             -- fade off
	#
	my $colorString = $_[0];
	my $cmd = "$blinkRaw $blinkDev $colorString";

	&debug("Running \'$cmd\'");
	system("$cmd");	

}

sub resetBlinkRaw {
	&callBlinkRaw('% _');
}

sub debug {
	my $debugString = shift(@_);
	print "DEBUG: " . $debugString . "\n" if ($debug);
}

sub intHandler {
	&resetBlinkRaw;
	exit 0;
}


MAIN: {
	$SIG{INT} = "intHandler";
	$SIG{TERM} = "intHandler";
	&resetBlinkRaw;
	while (1) {
		debug("Calling $bitMinterURL...");
		my $rate = &getBMHashRate($bitMinterAPIKey, $bitMinterURL);
		&debug("Hash Rate: $rate");
		
		&callBlinkRaw(&hashrateToColor($rate));
		sleep $pollInterval;
	}

}

