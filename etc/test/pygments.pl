#!/usr/bin/perl

use strict;
use warnings;
use Test::More;

sub which($) {
    my $cmd = shift or die;
    my @path = split /:/, $ENV{'PATH'};
    foreach (@path) {
        if (-x "$_/$cmd") {
            return 1;
        }
    }
}

system("yes | bash ./install_pygments.sh");
ok $? == 0;

ok which('pygmentize');
done_testing;
