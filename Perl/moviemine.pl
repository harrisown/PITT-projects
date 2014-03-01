#!/bin/perl -w
use Getopt::Long;
use LWP::Simple;
use strict;
use warnings;
my $minsup;
my $minconf;
my $maxmovies;
my $pos = '';
my $neg = '';
my $combo = '';
my @data_array = ();
my @item_array = ();
my @movies = ();
my @users = (0) x 933;
my @user_exists = (0) x 1000;
my %user = ("id_number" => 0);
my @movie_titles = ();
my @movie_exists = (0) x 1683;
GetOptions ('minsup=i' => \$minsup, 'minconf=i' => \$minconf, 'maxmovies=i' => \$maxmovies, 'pos' => \$pos, 'neg' => \$neg, 'combo' => \$combo);

open(FILE, "u.data");

while(<FILE>){
	chomp;
	my @line = split(' ', $_);
	push (@data_array, \@line);
}
my $data_length = @data_array;
for(my $i = 0; $i < $data_length; $i++){
			%user = ();
			my $user_id = $data_array[$i][0];
			if($user_exists[$user_id] == 0){
					$user{$data_array[$i][1]} = $data_array[$i][2];
					$users[$user_id] = %user;
					$user_exists[$user_id] = 1;
			}#else{
			
				#$users[$user_id]{$data_array[$i][1]} = $data_array[$i][2];
			#}

}
foreach my $elem (@users){
	print "$elem\n";
}
#print $data_array[0][0];
#print "\n";

open(ITEM, "u.item");

while(<ITEM>){
	chomp;
	my @line = split('\|',$_);
	push(@item_array, \@line);
}
#print $item_array[0][1];
#print "\n";

my $items = @item_array;

for (my $i = 0; $i < $data_length; $i++){
		my $movie_id = $data_array[$i][1]-1;
		push(@movies,$item_array[$movie_id][1]);#movies[0] is movie NAME
		push(@movies,$data_array[$i][2]);#movies[1] is ranking
		push(@movies,$data_array[$i][0]);#movies[2] is user ID
		push(@movies,$data_array[$i][1]);#movies[3] is movie ID
}


if($pos){
	print "Positive!\n\n";
	print "\t|";
	my $movie_length = @movies;
	for(my $i = 3; $i < $movie_length; $i+=4){
		if($movie_exists[$movies[$i]] == 0){
			push(@movie_titles,$movies[$i-3]);
			$movie_exists[$movies[$i]] = 1;
		}
	}
	#print "@movie_titles|";
	#print "\n";
	#print "@movie_exists";
	
}
