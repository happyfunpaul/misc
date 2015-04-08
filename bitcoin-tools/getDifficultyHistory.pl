#!/usr/bin/perl

use LWP::Simple;

$query="http://blockexplorer.com/q/nethash";
$wd="$HOME/bitcoin";


{
	my $content = get $query;
	die "Couldn't get $query" unless defined $content;
	@lines = split('\n',$content);
	print $content;
}


