#!/usr/bin/perl -w
use strict;
use warnings;
use Data::Dumper;
use Time::HiRes qw(time);
use List::MoreUtils qw(first_index);

# example via command line: perl wordpos.pl ASDJAIDOSASADIVIFDSK
# returns Alphabetical position of input string of all possible anagrams: 4691253285296 | Calculated in 0.000621s

sub init {
	my $start_time = time();

	# Ensure the input string follows proper format, otherwise just return false
	if ($_ !~ /^[A-Z]{2,20}$/) { return 0; }

	my @word_chars = split(//, $_);
	my @uniq_chars = sort(uniq(@word_chars));
	my %counts = frequency(@word_chars);
	my $position = 0;
	my $cur_word_char;

	# Find the word position of all possible combinations of its characters
	while (@word_chars) {
		$cur_word_char = shift @word_chars;
		foreach (@uniq_chars) {
			if ($cur_word_char eq $_) {
				$counts{$_} -= 1;
				if ($counts{$_} == 0) {
					my $index = first_index { $_ eq $cur_word_char } @uniq_chars;
					splice(@uniq_chars, $index, 1);
					delete $counts{$cur_word_char};
				}
				last;
			} else {
				# Calculate all possible permutations starting with the current unique character
				$position += permutations($_, %counts);
			}
		}
	}

	my $end_time = time();

	print "Alphabetical position of '$_' of all possible anagrams: " . ($position + 1);
	print "\n";
	printf("%s%.6f%s", "Calculated in ", $end_time - $start_time, "s\n");
}

# Find the unique values in an array
sub uniq {
	my %uniq;
	grep !$uniq{$_}++, @_;
}

# Compute the frequency of elements in an array
sub frequency {
	my %counts;

	foreach (@_) {
		$counts{$_}++;
	}

	return %counts;
}

# Calculate factorial in range 0...20 via memoization
my %table;
$table{0} = 1;

sub factorial {
	my $number = shift;
	my $factorial;

	if (exists $table{$number}) {
		return $table{$number};
	} else {
		$factorial = factorial($number - 1) * $number;
	}

	$table{$number} = $factorial;

	return $factorial;
}

# Compute the number possible permutations of a string's characters with a fixed start
sub permutations {
	my ($start, %counts) = @_;
	my ($total, $repetitions, $current) = (0, 1, 0);

	while (my ($chr, $count) = each(%counts)) {
		$current = ($chr eq $start) ? $count - 1 : $count;
		$total += $current;
		$repetitions *= factorial($current);
	}

	return factorial($total) / $repetitions;
}
# Call main function for each given command line argument
foreach (@ARGV) {
	init($_);
}