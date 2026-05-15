#!/usr/bin/env perl
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";
use Stakeholder::Runtime qw();

my ($exit_code, $stdout, $stderr) = Stakeholder::Runtime::run(@ARGV);
print $stdout if length $stdout;
print STDERR $stderr if length $stderr;
exit $exit_code;
