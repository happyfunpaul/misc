#!/usr/bin/perl

use LWP::Simple;

# This is when MtGox started. Honest.
$start=1279408157;
# now
$end=time();

$query="http://bitcoincharts.com/t/trades.csv?symbol=mtgoxUSD&start=${start}&end=${end}";
$wd="$HOME/bitcoin";


{
	my $content = get $query;
	die "Couldn't get $query" unless defined $content;
	@lines = split('\n',$content);
	print $content;
}


