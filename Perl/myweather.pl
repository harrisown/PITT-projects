#!/bin/perl -w
use Getopt::Long;
use LWP::Simple;
use POSIX qw(ceil);
use strict;
use warnings;

my $airport = '';
my $precipitation = '';
my $conditions = '';
my $lowest = '';
my $highest = '';
my $year = '';	
my $month = '';
my $average = '';
my $day = 1;
my $query = '';
my $page = '';
my $url = '';
my %months = ('1' => 'January','2' => 'February', '3' => 'March', '4' => 'April', '5' => 'May', '6' => 'June', '7' => 'July', '8' => 'August', '9' => 'September', '10' => 'October', '11' => 'November', '12' => 'December');

my @month_days = ('0','31','28','31','30','31','30','31','31','30','31','30','31');
GetOptions ('airport=s' => \$airport, 'year=i' => \$year, 'month=s' => \$month, 'average' => \$average, 'highest' => \$highest, 'lowest' => \$lowest, 'precipitation' => \$precipitation, 'conditions' => \$conditions);

sub Airport_Checker{
	my $var1 = $_[0];
	$url = "http://www.wunderground.com/history/airport/$var1/$year/$month/$day/DailyHistory.html?format=1";
    $page = get($url);
	my @page_values = split(',', $page);
	my $check = $page_values[0];
	chomp($check);
	if($check =~ m/^Time$/){ #All invalid airports just have "Time" as first website element
		die("\nERROR: INVALID AIRPORT CODE.\n");
	}
}


die("Invalid command line arguments, please make sure everything is included\n") unless ($airport&&$year&&$month&&($average||$highest||$lowest||$precipitation||$conditions));

&Airport_Checker($airport);

if ($average){
	$query = "Average";
	print "Station: $airport\n";
	print "Query: $query\n";
	my @accumulator = ();
	my @entire_page = ();
	my $total_temp = 0;
	my $average_temp = 0;
	my $lines = 0;
	my @high_average = ();
	my @low_average = ();
	my %highest_average = ('average' => 0, 'month'=> '', 'day' => '', 'year' => '');
	my %lowest_average = ('average' => 150, 'month'=> '', 'day' => '', 'year' => '');
	print "Computing...\n";
	my $iterator = 0;
	for($day = 1; $day <= $month_days[$month];$day++){
	    $total_temp = 0;
		$average_temp = 0;
		@accumulator = ();
		$url = "http://www.wunderground.com/history/airport/$airport/$year/$month/$day/DailyHistory.html?format=1";
		$page = get($url);
		die("\nERROR: INVALID URL") unless ($page);
		my @page_lines = split('\n',$page);
		$lines = @page_lines;
		#print "lines are $lines\n";
		#print "Page lines is $lines\n";
		@entire_page = split (',',$page);
		
		for(my $daytemp_iterator = 14, my $hour = 0; $hour < $lines-2; $daytemp_iterator+=13, $hour++){
			#print "Temperature for hour $hour is $entire_page[$daytemp_iterator]\n";
			@accumulator = (@accumulator, $entire_page[$daytemp_iterator]);
		}
		
		foreach my $elem (@accumulator){
			$total_temp = $total_temp + $elem;
		}
		my $accum_length = @accumulator;
		$average_temp = $total_temp/$accum_length;
		$average_temp = ceil($average_temp);
		
		unless ($iterator == 0){
			if($average_temp == $high_average[1]){
				$highest_average{"average"} = $average_temp;
				$highest_average{"month"} = $month;
				$highest_average{"day"} = $day;
				$highest_average{"year"} = $year;
				@high_average = (@high_average, %highest_average);
			}		
			if($average_temp == $low_average[1]){
				$lowest_average{"average"} = $average_temp;
				$lowest_average{"month"} = $month;
				$lowest_average{"day"} = $day;
				$lowest_average{"year"} = $year;
				@low_average = (@low_average, %lowest_average);
			}	
		}
		if($average_temp > $highest_average{average}){
			@high_average = ();
			$highest_average{"average"} = $average_temp;
			$highest_average{"month"} = $month;
			$highest_average{"day"} = $day;
			$highest_average{"year"} = $year;
			@high_average = (@high_average, %highest_average);
		}
		if($average_temp < $lowest_average{average}){
			@low_average = ();
			$lowest_average{"average"} = $average_temp;
			$lowest_average{"month"} = $month;
			$lowest_average{"day"} = $day;
			$lowest_average{"year"} = $year;	
			@low_average = (@low_average, %lowest_average);
		}
			
		print "$months{$month} $day, $year: $average_temp","F\n";
		$iterator++;
	}
	#print "Highest Average: $highest_average{average}","F","($months{$month} $highest_average{day}, $highest_average{year})\n";
	#print "Lowest Average: $lowest_average{average}","F","($months{$month} $lowest_average{day}, $lowest_average{year})\n";
	my $highs = @high_average;
    my $high_lows = @low_average;
		#foreach my $elem (@highests){
		#	print "$elem\n";
		#}
		for(my $i = 0; $i < $highs/8; $i++){ 
			print "Highest Month Average(s): ";
			print "$high_average[$i*8+1]","F","($months{$high_average[$i*8+3]} $high_average[$i*8+5], $high_average[$i*8+7])\n";
		}
		
		for(my $i = 0; $i < $high_lows/8; $i++){ 
			print "Lowest of Month Average(s): ";
			print "$low_average[$i*8+1]","F","($months{$low_average[$i*8+3]} $low_average[$i*8+5], $low_average[$i*8+7])\n";
		}
}






if($highest){
	$query = "Highest";
	print "Station: $airport\n";
	print "Query: $query\n";
	my @accumulator = ();
	my @entire_page = ();
	my $total_temp = 0;
	my $average_temp = 0;
	my $test_temp = 0;
	my $lines = 0;
	my @highests = ();
	my @month_high = ();
	my @month_high_low = ();
	my $iterator = 0;
	print "Computing...\n";
	for($day = 1; $day <= $month_days[$month] ;$day++){
		my %highest_temp = ('temp' => 0, 'month'=> '', 'day' => '', 'year' => '');
		@accumulator = ();
		$url = "http://www.wunderground.com/history/airport/$airport/$year/$month/$day/DailyHistory.html?format=1";
		$page = get($url);
		die("\nERROR: INVALID URL") unless ($page);
		my @page_lines = split('\n',$page);
		$lines = @page_lines;
		@entire_page = split (',',$page);
		for(my $daytemp_iterator = 14, my $hour = 0; $hour < $lines-2; $daytemp_iterator+=13, $hour++){
			@accumulator = (@accumulator, $entire_page[$daytemp_iterator]);
		}
		foreach my $elem (@accumulator){
			$test_temp = $elem;
		
			if($test_temp == $highest_temp{temp}){
				$highest_temp{"temp"} = $test_temp;
				$highest_temp{"month"} = $month;
				$highest_temp{"day"} = $day;
				$highest_temp{"year"} = $year;
				@highests = (@highests, %highest_temp);
				
			}		
			if($test_temp > $highest_temp{temp}){
				@highests = ();
				$highest_temp{"temp"} = $test_temp;
				$highest_temp{"month"} = $month;
				$highest_temp{"day"} = $day;
				$highest_temp{"year"} = $year;
				@highests = (@highests, %highest_temp);
			}
		
		}
			print "$highest_temp{temp}","F","($months{$month} $highest_temp{day}, $highest_temp{year})\n";
			
			if($iterator == 0){
				@month_high = (@month_high, %highest_temp);
				@month_high_low = (@month_high_low, %highest_temp);
			}
			#print "Highest month temp is $highest_temp{temp}\n";
			#print "Current Highest overall should be $month_high[1]\n";
			if($highest_temp{temp} == $month_high[1]){
				@month_high = (@month_high, %highest_temp);	
			}
			if($highest_temp{temp} == $month_high_low[1]){
				@month_high_low = (@month_high_low, %highest_temp);
			}
			if($highest_temp{temp} > $month_high[1]){
				#print "New High!\n";
				@month_high = ();
				@month_high = (@month_high, %highest_temp);
			}
			if($highest_temp{temp} < $month_high_low[1]){
				@month_high_low = ();
				@month_high_low = (@month_high_low,%highest_temp);
			}
			$iterator++;

    }
    my $highs = @month_high;
    my $high_lows = @month_high_low;
		#foreach my $elem (@highests){
		#	print "$elem\n";
		#}
		for(my $i = 0; $i < $highs/8; $i++){ 
			print "Highest Month temp(s): ";
			print "$month_high[$i*8+1]","F","($months{$month_high[$i*8+3]} $month_high[$i*8+5], $month_high[$i*8+7])\n";
		}
		
		for(my $i = 0; $i < $high_lows/8; $i++){ 
			print "Lowest of High Temp(s): ";
			print "$month_high_low[$i*8+1]","F","($months{$month_high_low[$i*8+3]} $month_high_low[$i*8+5], $month_high_low[$i*8+7])\n";
		}
	
}




if($lowest){
	$query = "Lowest";
	print "Station: $airport\n";
	print "Query: $query\n";
	my @accumulator = ();
	my @entire_page = ();
	my $total_temp = 0;
	my $average_temp = 0;
	my $test_temp = 0;
	my $lines = 0;
	my @lowests = ();
	my @month_low = ();
	my @month_low_high = ();
	my $iterator = 0;
	print "Computing...\n";
	for($day = 1; $day <= $month_days[$month] ;$day++){
		my %lowest_temp = ('temp' => 150, 'month'=> '', 'day' => '', 'year' => '');
		@accumulator = ();
		$url = "http://www.wunderground.com/history/airport/$airport/$year/$month/$day/DailyHistory.html?format=1";
		$page = get($url);
		die("\nERROR: INVALID URL") unless ($page);
		my @page_lines = split('\n',$page);
		$lines = @page_lines;
		@entire_page = split (',',$page);
		for(my $daytemp_iterator = 14, my $hour = 0; $hour < $lines-2; $daytemp_iterator+=13, $hour++){
			@accumulator = (@accumulator, $entire_page[$daytemp_iterator]);
		}
		foreach my $elem (@accumulator){
			$test_temp = $elem;
		
			if($test_temp == $lowest_temp{temp}){
				$lowest_temp{"temp"} = $test_temp;
				$lowest_temp{"month"} = $month;
				$lowest_temp{"day"} = $day;
				$lowest_temp{"year"} = $year;
				@lowests = (@lowests, %lowest_temp);
				
			}		
			if($test_temp < $lowest_temp{temp}){
				@lowests = ();
				$lowest_temp{"temp"} = $test_temp;
				$lowest_temp{"month"} = $month;
				$lowest_temp{"day"} = $day;
				$lowest_temp{"year"} = $year;
				@lowests = (@lowests, %lowest_temp);
			}
		
		}
			print "$lowest_temp{temp}","F","($months{$month} $lowest_temp{day}, $lowest_temp{year})\n";
			
			if($iterator == 0){
				@month_low = (@month_low, %lowest_temp);
				@month_low_high = (@month_low_high, %lowest_temp);
			}
			#print "Highest month temp is $highest_temp{temp}\n";
			#print "Current Highest overall should be $month_high[1]\n";
			if($lowest_temp{temp} == $month_low[1]){
				@month_low = (@month_low, %lowest_temp);	
			}
			if($lowest_temp{temp} == $month_low_high[1]){
				@month_low_high = (@month_low_high, %lowest_temp);
			}
			if($lowest_temp{temp} < $month_low[1]){
				#print "New High!\n";
				@month_low = ();
				@month_low = (@month_low, %lowest_temp);
			}
			if($lowest_temp{temp} > $month_low_high[1]){
				@month_low_high= ();
				@month_low_high = (@month_low_high,%lowest_temp);
			}
			$iterator++;

    }
    my $highs = @month_low;
    my $high_lows = @month_low_high;
		#foreach my $elem (@highests){
		#	print "$elem\n";
		#}
		for(my $i = 0; $i < $highs/8; $i++){ 
			print "Lowest Month temp(s): ";
			print "$month_low[$i*8+1]","F","($months{$month_low[$i*8+3]} $month_low[$i*8+5], $month_low[$i*8+7])\n";
		}
		
		for(my $i = 0; $i < $high_lows/8; $i++){ 
			print "Highest of Low Temp(s): ";
			print "$month_low_high[$i*8+1]","F","($months{$month_low_high[$i*8+3]} $month_low_high[$i*8+5], $month_low_high[$i*8+7])\n";
		}


}



if($precipitation){
	$query = "Precipitation";
	print "Station: $airport\n";
	print "Query: $query\n";
	my @accumulator = ();
	my @entire_page = ();
	my $total_precip = 0;
	my $day_precip = 0;
	my @precips = ();
	my @day_values = 0;
	print "Computing...\n";
	
	my $iterator = 0;
	$total_precip = 0;
	for($day = 1; $day <= $month_days[$month];$day++){
		$day_precip = 0;
		@accumulator = ();
		$url = "http://www.wunderground.com/history/airport/$airport/$year/$month/$day/DailyHistory.html?format=1";
		$page = get($url);
		die("\nERROR: INVALID URL") unless ($page);
		my @page_lines = split('\n',$page);
		my $lines = @page_lines;
		#print "Page lines is $lines\n";
		@entire_page = split (',',$page);
		
		for(my $daytemp_iterator = 22, my $line = 0; $line < $lines-2; $daytemp_iterator+=13, $line++){
			#print "Temperature for hour $hour is $entire_page[$daytemp_iterator]\n";
			@accumulator = (@accumulator, $entire_page[$daytemp_iterator]);
		}
		
		foreach my $elem (@accumulator){
			
			unless($elem =~ m/^N\/A$/){
				$day_precip += $elem;
			}
			
		}
		if($day_precip =~ m/T/i){
			$day_precip = 0.0;
		}
		
		@precips = (@precips, $day_precip);
		print "Precip total for $months{$month} $day, $year is: $day_precip in\n";
   }
   foreach my $elem (@precips){
			$total_precip += $elem;
	}
   	print "Total precipitation for $months{$month} is: $total_precip\n";
}
if($conditions){
	$query = "Conditions";
	print "Station: $airport\n";
	print "Query: $query\n";
	my @accumulator = ();
	my @entire_page = ();
	my @day_values = 0;
	print "Computing...\n";
	my %conditions = ();
	my $iterator = 0;
	my $lines = 0;
	for($day = 1; $day <= $month_days[$month];$day++){
		@accumulator = ();
		$url = "http://www.wunderground.com/history/airport/$airport/$year/$month/$day/DailyHistory.html?format=1";
		$page = get($url);
		die("\nERROR: INVALID URL") unless ($page);
		my @page_lines = split('\n',$page);
		$lines = @page_lines;
		#print "Page lines is $lines\n";
		@entire_page = split (',',$page);
		
		for(my $daytemp_iterator = 24, my $line = 0; $line < $lines-2; $daytemp_iterator+=13, $line++){
			#print "Temperature for hour $hour is $entire_page[$daytemp_iterator]\n";
			@accumulator = (@accumulator, $entire_page[$daytemp_iterator]);
		}
		
		foreach my $elem (@accumulator){
			chomp($elem);
			#print "$elem is the element!\n";
			if (exists ($conditions{$elem})){
				#print "here\n";
				$conditions{$elem}++;
			}else{
				#print "HERE\n";
				$conditions{$elem} = 1;
			}
		
     	}
     }
     $lines-=1;
     my $total_values = 0;
     foreach my $key(keys %conditions){
     	$total_values += $conditions{$key};
     }
     foreach my $key (sort {$conditions{$b} <=> $conditions{$a}} (keys(%conditions))){
     	#print "$conditions{$key} condition key\n";
     	#print "$total_values";
     	#print "$lines lines\n";
     	
     	my $percentage = $conditions{$key}/$total_values*100;
        $percentage = sprintf("%.1f", $percentage);
     	print "$percentage","%"," $key\n";
     }
     
}
