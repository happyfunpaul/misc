#!/usr/bin/perl

my $this_tstamp, $this_price, $this_volume, $this_date, %prices;

while (<>) {
	($this_tstamp,$this_price,$this_volume) = split(',');
	$this_date = getDateStr(localtime($this_tstamp));	
	$prices{$this_date}{count}++;
	$prices{$this_date}{total}+=$this_price;
}

foreach my $date_key (sort keys(%prices)) {

	my $avg = $prices{$date_key}{total} / $prices{$date_key}{count};
	print "$date_key $avg\n";
}

sub getDateStr {
	# Pass me a list from localtime()
	my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = @_;
        $year+=1900;  $mon++;
	$mon=sprintf "%02d", $mon;
	my $day=sprintf "%02d", $mday;
	return "$year/$mon/$day";	
}
