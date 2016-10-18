#!/usr/bin/perl -w

use strict;
use Data::Dumper;

my ($DT, @seg);

$DT = {};
while (<>) {
    chomp;
    s#^/##;
    @seg = split /\//;
    print "@seg\n";
    my ($s, $p);
    $p = $DT;
    foreach $s (@seg) {
	$p->{$s} = {} unless exists($p->{$s});
	$p = $p->{$s};
    }
}

DirTree2dot($DT);

sub DirTree2dot {
    my ($DT, $prefix) = @_;
    $prefix = '' unless defined $prefix;
    my (@x, $level, $indent, $k);
    @x = $prefix =~ /(_)/g;
    $level = $#x + 1;
    $indent = ' ' x ($level*2);
    print($indent . "subgraph cluster$prefix {\n");
    foreach $k (keys %$DT) {
	DirTree2dot($DT->{$k}, $prefix . "_$k");
    }
    print($indent . "}\n");
}

# $Data::Dumper::Indent = 1;
# print Dumper($DT);

