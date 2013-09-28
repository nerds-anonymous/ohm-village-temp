#!/usr/bin/perl 

use strict;
use warnings;

use LWP::UserAgent;
use HTML::TableExtract;

my $te = HTML::TableExtract->new( depth => 0 );
my $ua = LWP::UserAgent->new(agent => 'Mozilla 5.0',
	timeout => 30);

my $r = $ua->get('http://151.218.112.31/');
die $r->status_line if ! $r->is_success;
my $html = $r->content;
undef $r;

$te->parse($html);
my $table = $te->first_table_found;

open my $LF, '>>', '/root/fetch_coolness.log'
	or die $!;

foreach ($table->rows())
{
	next if $$_[0] eq "Id";
	print $LF join(';', @$_). "\n";
}

close $LF;

