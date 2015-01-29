#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use Cwd;
use File::Basename;
use Test::More;

my $root = basename(getcwd) eq "dotfiles" ? getcwd : Cwd::abs_path($FindBin::Bin . "/../..");
is basename($root), "dotfiles", "within dotfiles";

if ($root ne getcwd) {
    chdir $root;
}

ok -e "Makefile", "check Makefile";
my @list = map {$_ =~ s/\/?\n$//; $_} `make list 2>/dev/null`;
ok $? == 0, "make list";
cmp_ok @list, '>', 0, '@list > 0'
    or diag('@list is ' . @list);

foreach my $f (@list) {
    my $a = "$root/$f";
    my $b = readlink("$ENV{'HOME'}/$f");

    (my $bdash = $b) =~ s/^.*(dotfiles\/.*)/$1/;
    is $a, $b, "$bdash -> $ENV{'HOME'}/$f";
}

done_testing;
