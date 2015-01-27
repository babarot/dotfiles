#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use Cwd;
use Test::More;

my $root = Cwd::abs_path($FindBin::Bin . "/../");
like "$root", qr/dotfiles\/(?:(?!\/).)*$/, 'within dotfiles/etc';

my @list = glob "$root/init/{,osx/}*.sh";
cmp_ok @list, '>', 1, '@list > 1';

foreach my $f (@list) {
    # Check debug mode init scripts
    system("DEBUG=1 bash $f >/dev/null");

    # Shorten path
    $f =~ s/^.*dotfiles\///;

    ok $? == 0, $f;
}
done_testing;
