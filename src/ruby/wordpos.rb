##
# example via command line: php wordpos.php ASDJAIDOSASADIVIFDSK
# returns Alphabetical position of input string of all possible anagrams: 4691253285296, calculated in 0.000334 seconds
##

require 'benchmark'

class WordPosition
	def initialize(string)
		time = Benchmark.measure do
			# ensure the input string follows proper format, otherwise just return false
			return nil if /^[A-Z]{2,20}$/ !~ string

			word_chars = string.split('')
			uniq_chars = word_chars.uniq.sort
			counts = self.frequency(word_chars)
			position = 0

			# find the word position of all possible combinations of its characters
			while word_chars.size > 0
				cur_word_char = word_chars.shift
				l = uniq_chars.size
				uniq_chars.each do |cur_uniq_char|
					if cur_word_char == cur_uniq_char
						counts[cur_uniq_char] -= 1
						if counts[cur_uniq_char] == 0
							uniq_chars.slice!(uniq_chars.index(cur_word_char), 1)
							counts.delete(cur_word_char)
						end
						break
					else
						# calculate all possible permutations starting with the current unique character
						position += self.permutations(cur_uniq_char, counts)
					end
				end
			end
		end
		puts 'Alphabetical position of input string of all possible anagrams: ' << (position + 1) << ', calculated in ' << time << ' seconds'
	end

	##
	# Compute the frequency of elements in an array
	# @param array $array Array containing elements to count
	# @return array Unique character keys with frequency values
	##
	def self.frequency(array)
		array.each_with_object(Hash.new(0)) { |key, hash| hash[key] += 1 }
	end

	##
	# Calculate factorial in range 0...20 via memoization
	# @param integer $n Input integer
	# @return integer Calculated factorial
	##
	def self.factorial(n)
		(1..n).reduce(:*) || 1
	end

	##
	# compute the number possible permutations of a string's characters with a fixed start
	# @param string $start Unique character
	# @param array $counts Associative array of each character with their frequencies
	# @return number
	##
	def self.permutations(start, counts)
		total = 0
		repetitions = 1
		current = 0

		counts.each do |key, char|
			current = (char === start) ? counts[chr] - 1 : counts[chr]
			total += current
			repetitions *= self.factorial(current)
		end

		self.factorial(total) / repetitions
	end
end

# call the class for each given command line argument
#str = ARGV.shift
#line = ARGV.shift
ARGV.each do |s|
	WordPosition.new(s)
end