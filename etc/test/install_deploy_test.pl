#!/usr/bin/perl

use strict;
use warnings;
use File::Spec;
use FindBin;
use Cwd;

my $root = Cwd::abs_path($FindBin::Bin . "/../..");

chdir $root;
if (-f "Makefile") {
    my $make_list=`make list 2>/dev/null`;
    if ($? != 0) {
        exit 1;
    }
    my @list = split(/\n/, $make_list);
    @list = map {$_ =~ s@/$@@; $_} @list;

    foreach my $path (@list) {
        my $a = "$root/$path";
        my $b = readlink("$ENV{'HOME'}/$path");
        if ($a ne $b) {
            exit 1;
        }
    }
} else {
    exit 1;
}
