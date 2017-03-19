#!/usr/bin/perl -w

use strict;
use Data::Dumper;

my ($DT, @seg, @passthrough);

$DT = {};
while (<>) {
    chomp;
    s/#.*//;
    s/^\s*//;
    if (s#^/##) {
	# a path
	@seg = split /\//;
	my ($s, $p);
	$p = $DT;
	foreach $s (@seg) {
	    $p->{$s} = {} unless exists($p->{$s});
	    $p = $p->{$s};
	}
    } elsif (s#^@##) {
	push @passthrough, "  $_\n";
    } elsif (/^$/) {
	next;
    } else {
	print "warning: ignored: $_\n";
    }
}

print <<EOF;
digraph G {
  rankdir = LR;
  overlap = scale;
  # http://www.graphviz.org/content/global-subgraph-style-statements
  graph [shape="folder", style="rounded"];
  node [shape="note", color="blue", fontcolor="blue"];
  edge [style=invis];
EOF

DirTree2dot($DT);
print(@passthrough, "\n}\n");

sub DirTree2dot {
    my ($DT, $fullpath) = @_;
    $fullpath = '' unless defined $fullpath;
    my ($name, @x, $level, $indent, $k);
    ($name) = $fullpath =~ m#.*/(.*)$#;
    $name = '/' unless $name;
    @x = $fullpath =~ m#(/)#g;
    $level = $#x + 1;
    $indent = ' ' x ($level*2+2);
    @x = keys %$DT;
    if ($#x >= 0) {
	print($indent . qq(subgraph "cluster$fullpath" {\n$indent  label="$name";\n));
	foreach $k (@x) {
	    DirTree2dot($DT->{$k}, $fullpath . "/$k");
	}
	print($indent . "}\n");
    } else {
	print(qq($indent"$fullpath" [ label="$name"];\n));
    }
}

# $Data::Dumper::Indent = 1;
# print Dumper($DT);

