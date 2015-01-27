#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use Cwd;
use File::Basename;
use Test::More;

my $root = basename(getcwd) eq "dotfiles" ? getcwd : Cwd::abs_path($FindBin::Bin . "/../..");
is basename($root), "dotfiles", "within dotfiles";

chdir $root;
my @list = map {$_ =~ s/\/?\n$//; $_} `make list 2>/dev/null`;
cmp_ok @list, '>', 1, '@list > 1'
    or diag('@list is ' . @list);

foreach my $f (@list) {
    my $a = "$root/$f";
    my $b = readlink("$ENV{'HOME'}/$f");

    (my $adash = $a) =~ s/^$ENV{'HOME'}/~/;
    (my $bdash = $b) =~ s/^.*(dotfiles\/.*)/$1/;
    is $a, $b, "$adash -> $bdash";
}

done_testing;
