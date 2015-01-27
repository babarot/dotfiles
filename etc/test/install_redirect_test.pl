#!/usr/bin/perl

use strict;
use LWP::UserAgent;
use Data::Dumper;
use Test::More;

my $redirect = "https?:\/\/raw\.github.*\.com\/b4b4r07\/dotfiles\/master\/etc\/install";
my $url = 'http://dot.b4b4r07.com';

my $ua = LWP::UserAgent->new();
my $response = $ua->get($url);
my $uri = $response->request->uri;

like "$uri", qr/$redirect/, "$uri -> $url";
done_testing;
