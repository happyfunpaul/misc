#!/usr/local/bin/perl

# Calculate the Nth number of the Fibbonaci seq.
# 1, 1, 2, 3, 5, 8, 13, 21...

#old, busted method that uses recursive iteration,
#and code that is a PITA to read....
sub f {
	my $n = shift;
	return $n < 2 ? 1 : f($n-1) + f($n-2);
    }

#fancy new method that uses mathemagic to derive the
#number much more quickly.
sub f2 {
	my $n = shift;
	my $phi = (1+sqrt(5)) / 2;
	return int(($phi ** ($n+1)) / sqrt(5) + 0.5);
}

#slightly less geeky appraoch is to "cache" calculations,
# since the big slow-down is in calculating the same thing over
# and over again.
my @cache;

sub fc {
	my $n = shift;
	return 1 if ($n < 2);
	return $cache[$n] if ($cache[$n] > 0);
	# If we get here, we need to cache it.
	$cache[$n] = fc($n-1) + fc($n-2);
	return $cache[$n];
}

#print f2($ARGV[0]), "\n";
print f($ARGV[0]), "\n";
