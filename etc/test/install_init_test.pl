#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use Cwd;

my $root = Cwd::abs_path($FindBin::Bin . "/../");
my @list = glob "$root/init/{,osx/}*.sh";

foreach my $f (@list) {
    # Check debug mode init scripts
    system("DEBUG=1 bash $f >/dev/null");
    my $exit_code = $?;

    # Shorten path
    $f =~ s/^.*dotfiles\///;

    if ($exit_code == 0) {
        print "ok: $f\n";
    } else {
        print "NG: $f\n";
        exit 1;
    }
}
