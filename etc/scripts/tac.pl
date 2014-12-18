#!/usr/local/bin/perl
# Oneliner: perl -e 'print reverse <>'
use strict;
use warnings;

@ARGV or die "$0 [files...]";

for my $filename ( reverse @ARGV ) {
    open my $fh, '<', $filename or die "$filename:$!";
    my @loc;
    push @loc, tell($fh) while (<$fh>);
    seek $fh, $_, 0 and print scalar <$fh> for ( reverse @loc );
    close $fh;
}
