#!/usr/bin/perl -w
#
# File: advanced-ds4.pl
# Desc: Advanced Data Structures
# Auth: Alexandros Labrinidis (labrinid@cs.pitt.edu)
# Date: Thu Sep 20 14:32:43 EDT 2012
#

sub myline {
my ($inp) = @_;
print '-'x25, " $inp ", '-'x25, "\n";
}

# HASHES IN ARRAYS
@arhas = ( { 'name' => 'alex', 'office' => "6105"},
{ 'name' => 'panos', 'office' => "6421"},
{ 'name' => 'adam', 'office' => "6109"},
{ 'name' => 'alex', 'office' => "6107"});

sub lookup {
my ($inp_name) = @_;

my ($found) = 0;
foreach $iter (@arhas) {
if ($$iter{'name'} eq $inp_name) {
print $inp_name."'s office is ", $$iter{'office'}, "\n";
$found = 1;
}
}
return $found;
}

myline("Interactive Mode");
print "Please enter a name: ";
while (<>) {
$myname = $_;
chomp($myname);

print "\n=====> Looking for an office for $myname <=====\n";

if ($myname eq 'exit') {
myline("Quiting time!");
exit(0);
}

if (!lookup($myname)) {
print ("$myname does not have an office\n");
}
}