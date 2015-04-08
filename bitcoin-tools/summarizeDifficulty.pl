#!/usr/bin/perl

my %diffs;
my $this_blocknum,$this_tstamp,$this_tgt,$this_avgtgtlast,$this_diff,$this_hashes2win,$this_ivallast,$this_hashsec;

while (<>) {
	next unless /^\d+/;
	($this_blocknum,$this_tstamp,$this_tgt,$this_avgtgtlast,$this_diff,
		$this_hashes2win,$this_ivallast,$this_hashsec) = split(',');

	# Don't bother with time periods too early for us to have trading data.
	next unless ($this_tstamp > 1279408157);

	$this_date = getDateStr(localtime($this_tstamp));	
	$diffs{$this_date}{count}++;
	$diffs{$this_date}{total}+=$this_diff;
}

foreach my $date_key (sort keys(%diffs)) {

	my $avg = $diffs{$date_key}{total} / $diffs{$date_key}{count};
	print "$date_key $avg\n";
}

sub getDateStr {
	# Pass me a list from localtime()
	my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = @_;
        $year+=1900; $mon++;
	$mon=sprintf "%02d", $mon;
	my $day=sprintf "%02d", $mday;
	return "$year/$mon/$day";	
}
