#!/usr/bin/perl
use strict;
use warnings;
use feature 'say';
use LWP::UserAgent;
use HTTP::Request::Common;

my $yo_api_token = $ARGV[0];
my $user = $ARGV[1];
my $sleeptime = $ARGV[2];

say "SEND YO $user $sleeptime later";
sleep($sleeptime);
 
my $url = 'http://api.justyo.co/yo/';
my %postdata = (
	'api_token' => $yo_api_token,
	'username'  => $user,
);
my $request = POST($url, \%postdata);

my $ua = LWP::UserAgent->new;

for (my $ct = 0; $ct < 4; $ct++){
	my $res = $ua->request($request);
	say $res->as_string;
  if ($res->content eq '{"result": "OK"}'){
		say "Sent YO!";
		last;
	}
	say "send again 60 seconds later";
	sleep 60;
}

exit;




