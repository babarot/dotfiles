#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use Cwd;
use File::Basename;

sub do_test {
    my ($root) = @_;
    chdir $root;

    if (-f "Makefile") {
        my $make_list=`make list 2>/dev/null`;
        if ($? != 0) {
            print "make list: failed\n";
            exit 1;
        }

        my @list = split(/\n/, $make_list);
        @list = map {$_ =~ s@/$@@; $_} @list;

        foreach my $f (@list) {
            my $a = "$root/$f";
            my $b = readlink("$ENV{'HOME'}/$f");

            if ($a eq $b) {
                $b =~ s/^.*(dotfiles\/.*)/$1/;
                print "ok: $ENV{'HOME'}/$f -> $b\n";
            } else {
                print "NG: $a\n";
                exit 1;
            }
        }
    } else {
        print "Makefile: not found\n";
        exit 1;
    }
}

if (basename(getcwd) eq "dotfiles") {
    &do_test(getcwd);
} else {
    my $root = Cwd::abs_path($FindBin::Bin . "/../..");
    if (basename($root) eq "dotfiles") {
        &do_test($root);
    } else {
        print "This is not dotfiles directory\n";
        exit 1;
    }
}
