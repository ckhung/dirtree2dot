#!/usr/bin/perl -w

use strict;
use Data::Dumper;

my ($DT, @seg);

$DT = {};
while (<>) {
    next if /^\s*#/;
    chomp;
    s#^/##;
    @seg = split /\//;
    my ($s, $p);
    $p = $DT;
    foreach $s (@seg) {
	$p->{$s} = {} unless exists($p->{$s});
	$p = $p->{$s};
    }
}

print <<EOF;
digraph G{
  rankdir = LR;
  overlap = scale;
  # http://www.graphviz.org/content/global-subgraph-style-statements
  graph [shape="folder", style="rounded"];
  node [shape="note", color="blue", fontcolor="blue"];
  edge [style=invis];
EOF

DirTree2dot($DT);

print "}\n";

sub DirTree2dot {
    my ($DT, $fullpath) = @_;
    $fullpath = '' unless defined $fullpath;
    my ($name, @x, $level, $indent, $k);
    ($name) = $fullpath =~ /.*_(.*)$/;
    $name = '/' unless $name;
    @x = $fullpath =~ /(_)/g;
    $level = $#x + 1;
    $indent = ' ' x ($level*2+2);
    @x = keys %$DT;
    if ($#x >= 0) {
	print($indent . qq(subgraph "cluster$fullpath" {\n$indent  label="$name";\n));
	foreach $k (@x) {
	    DirTree2dot($DT->{$k}, $fullpath . "_$k");
	}
	print($indent . "}\n");
    } else {
	print(qq($indent"$fullpath" [ label="$name"];\n));
    }
}

# $Data::Dumper::Indent = 1;
# print Dumper($DT);

