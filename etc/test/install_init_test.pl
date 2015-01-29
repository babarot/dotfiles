#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use Cwd;
use Test::More;

my $root = Cwd::abs_path($FindBin::Bin . "/../");
like "$root", qr/dotfiles\/(?:(?!\/).)*$/, 'within dotfiles/etc';

my @list = glob "$root/init/{,osx/}*.sh";
cmp_ok @list, '>', 0, '@list > 0';

foreach my $f (@list) {
    # Check debug mode init scripts
    system("DEBUG=1 bash $f >/dev/null");

    # Shorten path
    #$f =~ s/^.*dotfiles\///;
    #ok $? == 0, sub{my $a = shift; $a =~ s/^.*dotfiles\///; $a}->($f);
    #ok $? == 0, sub{s/^.*dotfiles\///; $_}->($f);
    ok $? == 0, sub($) {
        my $v = shift;
        $v =~ s/^.*dotfiles\///; $v;
    }->($f);
}
done_testing;
