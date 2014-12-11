#!/usr/bin/env perl
# -*- mode:perl; coding:utf-8 -*-
#
# scat.pl -
#
# Copyright(C) 2009 by mzp
# Author: MIZUNO Hiroki / mzpppp at gmail dot com
# http://howdyworld.org
#
# Timestamp: 2009/09/14 21:50:38
#
# This program is free software; you can redistribute it and/or
# modify it under MIT Licence.
#

use strict;
use warnings;
use Data::Dumper;
use File::Basename;
use List::Util qw();

sub rows() {
	my $s = `stty -a`;
	$s =~ /(\d+) rows/ or die "row error";
	$1;
}

sub is_over($) {
	my ($rows) = @_;
	my $n = 0;
	for(<>) {
		$n ++;
		if($rows < $n) { return 1; }
	}
	return 0;
}

if (@ARGV > 0) {
	if ($ARGV[0] eq '-h' || $ARGV[0] eq '--help') {
		my $pn = basename($0);
		print "Usage: $pn [-h | --help] file\n";
		print "Automatically cat or less (pager).\n\n";
		exit (1);
	}
}

my @orig = @ARGV;
if(is_over(rows)) {
	system "less @orig 2>/dev/null";
} else {
	system "cat @orig 2>/dev/null";
}
