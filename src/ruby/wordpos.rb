# example via command line: ruby wordpos.rb ASDJAIDOSASADIVIFDSK
# returns Alphabetical position of input string of all possible anagrams: 4691253285296 | Calculated in 0.000363s

require "benchmark"

class WordPosition
	def initialize(string)
		time = Benchmark.measure do
			# ensure the input string follows proper format, otherwise just return false
			return nil if /^[A-Z]{2,20}$/ !~ string

			word_chars = string.split("")
			uniq_chars = word_chars.uniq.sort
			counts = frequency(word_chars)
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
						position += permutations(cur_uniq_char, counts)
					end
				end
			end
			puts "Alphabetical position of '#{string}' of all possible anagrams: #{position + 1}"
		end
		puts "Calculated in #{time.real}s"
	end

	# compute the frequency of elements in an array
	# @param array {array} - array containing elements to count
	# @return array unique character keys with frequency values
	def frequency(array)
		array.each_with_object(Hash.new(0)) { |key, hash| hash[key] += 1 }
	end

	# calculate factorial in range 0...20 via memoization
	# @param {integer} n - input integer
	# @return {integer} calculated factorial
	def factorial(n)
		(1..n).reduce(:*) || 1
	end

	# compute the number possible permutations of a string's characters with a fixed start
	# @param string {start} - unique character
	# @param array {counts} associative array of each character with their frequencies
	# @return number
	def permutations(start, counts)
		total = 0
		repetitions = 1
		current = 0

		counts.each do |char, count|
			current = (char === start) ? count - 1 : count
			total += current
			repetitions *= factorial(current)
		end

		factorial(total) / repetitions
	end
end

# call the class for each given command line argument
ARGV.each do |s|
	WordPosition.new(s)
end