#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use Cwd;

my $root = Cwd::abs_path($FindBin::Bin . "/../");
my @list = ();
push(@list, glob "$root/init/*.sh");
push(@list, glob "$root/init/osx/*.sh");

foreach my $f (@list) {
    system("DEBUG=1 bash $f >/dev/null");
    if ($? == 0) {
        print "ok: $f\n";
    } else {
        print "NG: $f\n";
        exit 1;
    }
}
