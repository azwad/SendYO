#!/usr/bin/perl
use Mojolicious::Lite;
#use lib '/home/toshi/perl/lib';
use utf8;
use feature qw( say );
use Switch;
use Tweet;

get '/err' => sub{
	my $self = shift;
	return $self->render('err');
};


get '/robots.txt' => sub{
	my $self = shift;
	return $self->redirect_to('/err');
};


get '/:dir' => sub{
	my $self = shift;
	my $dir = $self->param('dir');
	$self->redirect_to('/err') if $dir !~ m|yocallback[1-3]$|;
	$dir =~ m|yocallback(.)$|;
	my $num = $1;
  my $username = $self->req->param('username') || '';
  $self->redirect_to('/err') if $username eq '';

	my $pit_account;
	my $twitter_account;
  my $my_yo_name;
	my $yo_api_token;
	my $sleeptime;

	switch ($num) {
		case 1 {  $pit_account = 'twitter.toshi0104';
							$twitter_account = '@toshi0104';
							$my_yo_name = 'TOSHIAZWAD';
							$yo_api_token = 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx';
							$sleeptime = 60;
						}
		case 2 {  $pit_account = 'twitter.JapanTechFeeds';
							$twitter_account = '@JapanTechFeeds';
							$my_yo_name = 'JAPANTECHFEEDS';
							$yo_api_token = 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx';
							$sleeptime = 300;
						}
		case 3 {  $pit_account = 'toshi.private';
							$twitter_account = '@_toshi';
							$my_yo_name = 'AZWAD0724';
							$yo_api_token = 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx';
							$sleeptime = 1800;
						}
	};

	my $timestr;
	switch ($sleeptime) {
		case   60 { $timestr = "1 Minute"}
		case  300 { $timestr = "5 Minutes"}
		case  600 { $timestr = "10 Minutes"}
		case 1800 { $timestr = "30 Minutes"}
		case 3600 { $timestr = "One Hour"}
	};

#	my $yo_revenge_path = "http://justyo.co/" . $username;
	my $url = "http://justyo.co/$my_yo_name";
	my $message = "
Get YO! from $username " . localtime . "\n" .
"Send Back YO! $timestr Later.\n
\n
SEND YO TO $my_yo_name. ";

	my  $twitter = Tweet->new();
	$twitter->init({
		'pit_twitter' => $pit_account,
		'pit_bitly' => 'bit.ly',
 		}
	);
	$twitter->post_tweet($message,$url);
	if ($twitter->is_success){
		say "post: $message";
		system "./post.pl $yo_api_token $username $sleeptime &";
	}else{
		say  "post failed";
	}
	
	$self->stash(
		message => $message,
	);
	$self->render();
} => 'default';


get '/*' => sub{
	my $self = shift;
	$self->redirect_to('/err');
};


get '/' => sub{
	my $self = shift;
	$self->redirect_to('/err');
};

app->start;

__DATA__
@@ default.html.ep
message : <%= $message %>

@@ err.html.ep
err
