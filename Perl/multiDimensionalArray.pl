#!/usr/bin/perl -w
#
# File: advanced-ds2.pl
# Desc: Advanced Data Structures
# Auth: Alexandros Labrinidis (labrinid@cs.pitt.edu)
# Date: Thu Sep 20 14:32:43 EDT 2012
#

sub myline {
my ($inp) = @_;
print '-'x25, " $inp ", '-'x25, "\n";
}

myline("one");
$one = [ 'el-1', 'el-2', 'el-3', 'el-4', 'el-5'];
print $one,"\n";
foreach $iter (@$one) {
print "*$iter*\n";
}
print "Element [1] is ", $$one[1],"\n";
print "Element [2] is ", $one->[2],"\n";

myline("two");
$two = { 'k-1' => 'el-1', 'k-2' => 'el-2', 'k-3' => 'el-3'};
print $two,"\n";
foreach $iter (keys(%$two)) {
print "*$iter -> ", $$two{$iter}, "*\n";
}
print "Element [k-2] is ", $$two{'k-2'},"\n";
print "Element [k-3] is ", $two->{'k-3'},"\n";

