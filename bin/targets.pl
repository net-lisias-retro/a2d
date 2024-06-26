#!/usr/bin/env perl

# Process TARGETS file:
#  targets.pl < TARGETS            -- file,path,disposition
#  targets.pl targets < TARGETS    -- file
#  targets.pl dirs < TARGETS       -- path (sorted, unique)
#
# TARGETS file structure - lines are whitespace-delimited
#  # comment
#  target.name         target/dir/path        disposition
#  target.name         target/dir/path        disposition

use v5.10;
use strict;
use warnings;

my $command = shift(@ARGV) // "";

my @dirs = ();

while (<STDIN>) {
  chomp();
  s/#.*$//g;
  next unless $_;

  my ($target, $path, $disposition) = split();

  if ($command eq "targets") {
    print $target, "\n";
  } elsif ($command eq "dirs") {
    push @dirs, $path;
  } elsif ($command eq "") {
    print $target, ",", $path, ",", $disposition, "\n";
  } else {
    die "Unknown command: $command\n";
  }
}

if ($command eq "dirs") {
  my %hash;
  @hash{@dirs} = ();
  foreach my $dir (sort keys %hash) {
    print $dir, "\n";
  }
}
