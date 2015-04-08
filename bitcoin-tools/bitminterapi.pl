#!/usr/local/bin/perl

use JSON::Parse 'parse_json';

my $apikey="LOLNOPE";
my $userdata_url="https://bitminter.com/api/users/USERNAMEHERE";

my $out = `curl -s -H "Authorization: key=$apikey" $userdata_url`;
my $json_ref = parse_json($out);

my %json_hash = %$json_ref;

print "Hash Rate: $json_hash{hash_rate}\n";

