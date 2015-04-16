# example via command line: python wordpos.py ASDJAIDOSASADIVIFDSK
# returns Alphabetical position of input string of all possible anagrams: 4691253285296 | Calculated in 0.000188s

import collections
import re
import sys
import timeit
from math import factorial

class WordPosition:
	def __init__(self, string):
		start_time = timeit.default_timer()
		# ensure the input string follows proper format, otherwise just return nil
		if re.match('^[A-Z]{2,20}$', string) is not None:
			word_chars = list(string)
			uniq_chars = sorted(set(word_chars))
			counts = self.frequency(word_chars)
			position = 0

			# find the word position of all possible combinations of its characters
			while len(word_chars) > 0:
				cur_word_char = word_chars.pop(0)
				for cur_uniq_char in uniq_chars:
					if cur_word_char == cur_uniq_char:
						counts[cur_word_char] -= 1
						if counts[cur_word_char] == 0:
							uniq_chars.remove(cur_word_char)
							counts.pop(cur_word_char)
						break
					else:
						# calculate all possible permutations starting with the current unique character
						position += self.permutations(cur_uniq_char, counts)
			elapsed = timeit.default_timer() - start_time
			print "Alphabetical position of '%s' of all possible anagrams: %d" % (string, position + 1)
			print "Calculated in %fs" % elapsed

	# compute the frequency of elements in an array
	# @param {array} array - contains elements to count
	# @return {hash} unique character keys with frequency values
	@staticmethod
	def frequency(array):
		counts = collections.defaultdict(int)
		for char in array:
			counts[char] += 1
		return counts

	# compute the number possible permutations of a string's characters with a fixed start
	# @param {string} start - unique character
	# @param {hash} counts - contains each character with their frequencies
	# @return {number} permutation count
	@staticmethod
	def permutations(start, counts):
		total = 0
		repetitions = 1
		current = 0

		for char, count in counts.items():
			current = count - 1 if (char == start) else count
			total += current
			repetitions *= factorial(current)

		return factorial(total) / repetitions

# call the class for each given command line argument
for arg in sys.argv:
	WordPosition(arg)