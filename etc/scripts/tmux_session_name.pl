#!/usr/bin/env perl

use strict;
use warnings;

if (exists $ENV{'TMUX'}) {
    # session ID is the last element
    # /tmp/1s/ffkjhk76sdgn/T/tmux-771/default,16772,8
    my($id) = $ENV{'TMUX'};
    $id =~ s{^.*,(\d+)$}{$1};

    # get session name
    my($cmd) = q(tmux ls -F "#{session_name}: #{session_id}");
    open(IN, "$cmd |") || die qq([ERROR] Cannot open pipe from "$cmd" - $!\n);

    while (<IN>) {
        chomp;

        if (m{(^.*):\s+\$$id$}) {
            print "Session name: $1\n";
            exit 0;
        }
    }

    print "Unable to determine TMUX session name\n";
    exit 1;
}
else {
    print "Not in a TMUX session\n";

    exit 1;
}
