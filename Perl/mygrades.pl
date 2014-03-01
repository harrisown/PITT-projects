#!/bin/perl -w
#mygrades.pl
use Getopt::Long;
use LWP::Simple;
use strict;
use warnings;

my $stu = '';
my $gra = '';
my $sid = 0;
my $transcript = '';
my %student = ("id" => "0", => "firstname" => "", "lastname" => "", "year" => "");
my %course = ("course" => "", "year_taken" => 0,"month_taken" => 0,"credits" => 0, "grade" => 0);
my @courses_hash = ({"course" => "", "year_taken" => 0,"month_taken" => 0,"credits" => 0, "grade" => 0},{"course" => "", "year_taken" => 0,"month_taken" => 0,"credits" => 0, "grade" => 0},{"course" => "", "year_taken" => 0,"month_taken" => 0,"credits" => 0, "grade" => 0},{"course" => "", "year_taken" => 0,"month_taken" => 0,"credits" => 0, "grade" => 0});
my @line;
my $id;
my $firstname;
my $lastname;
my $year;
my $course;
my $year_taken;
my $month_taken;
my $credits;
my $grade;
my $onekey;
my $onevalue;
my $course_number = 0;

GetOptions ('stu=s' => \$stu, 'gra=s' => \$gra, 'sid=i' => \$sid, 'transcript' => \$transcript);

open (STUDENT_FILE, $stu);
while(<STUDENT_FILE>){
	@line = split("\n");
	if($line[0] =~m /^1/){
		%student = ();
		($id, $firstname, $lastname, $year) = split("::");
		$student{"id"} = $id;
		$student{"firstname"} = $firstname;
		$student{"lastname"} = $lastname;
		$student{"year"} = $year;
		if($id =~m /$sid/){
			last;
		}
	}
}
close(STUDENT_FILE);
#print %student;

open (GRADES_FILE, $gra);
while(<GRADES_FILE>){
	@line = ();
	@line = split("\n");
	$course_number = 0;
	if($line[0] =~m /^$sid/){
		%course = ();
		($id,$course, $year_taken, $month_taken,$credits,$grade) = split("::");
		$courses_hash[$course_number]{"course"} = $course;
		$courses_hash[$course_number]{"year_taken"} = $year_taken;
		$courses_hash[$course_number]{"month_taken"} = $month_taken;
		$courses_hash[$course_number]{"credits"} = $credits;
		$courses_hash[$course_number]{"grade"} = $grade;
		$course_number++;
		
	}
}
close(GRADES_FILE);
#print @courses_hash;

print "TRANSCRIPT-BEGIN\n\n";
print "StudentID: $id\n";
print "Name: $student{firstname} $student{lastname}\n";
print "Year: $student{year}\n\n";
print "GRADES RECORDED:\n";

foreach my $iter (@courses_hash) {
		print "$$iter{course} -- $$iter{month_taken} -- $$iter{year_taken} -- $$iter{credits} credits -- $$iter{grade}\n";
		$course_number--;
		if($course_number <= 0){
			last;
		}
	
}
