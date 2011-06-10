#!/usr/bin/perl

use strict;
use warnings;

use Data::Dump qw/pp/;

use lib 'lib';
use OBal::API;
use OBal::Schema;


my $schema = OBal::Schema->connect('dbi:mysql:options', 'root', 'root', {mysql_enable_utf8 => 1});

my $api = OBal::API->new(schema => $schema);


print "Usage: $0 SYMBOL [PRICE]\n" unless @ARGV;

warn pp $api->by_symbol(@ARGV);
