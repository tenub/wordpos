function WordPosition(string)
{
	this.init = function() {
		// ensure the input string follows proper format, otherwise just return false
		if (string.match(/^[A-Z]{2,20}$/g) === null) { return false; }

		var cur_word_char;
		var cur_uniq_char;
		var word_chars = string.split('');
		var uniq_chars = getUniqChars(word_chars).sort();
		var counts = frequency(word_chars);
		var position = 0;

		// find the word position of all possible combinations of its characters
		while (word_chars.length > 0) {
			cur_word_char = word_chars.shift();
			for (var i = 0, l = uniq_chars.length; i < l; i++) {
				cur_uniq_char = uniq_chars[i];

				if (cur_word_char === cur_uniq_char) {
					counts[cur_uniq_char] -= 1;
					if (counts[cur_uniq_char] === 0) {
						uniq_chars.splice(uniq_chars.indexOf(cur_word_char), 1);
						delete counts[cur_word_char];
					}
					break;
				} else {
					// calculate all possible permutations starting with the current unique character
					position += permutations(cur_uniq_char, counts);
				}
			}
		}

		return position + 1;
	};

	/**
	 * find the unique characters in an array
	 * @param {array} array - array of characters
	 * @return {array} unique array
	 */
	function getUniqChars(array) {
		return array.filter(function(chr, i) {
			return array.indexOf(chr) === i;
		});
	}

	/**
	 * compute the frequency of elements in an array
	 * @param {array} array - array containing elements to count
	 * @return {object} unique character keys with frequency values
	 */
	function frequency(array) {
		var counts = {};

		for (var i = 0, l = array.length; i < l; i++) {
			var num = array[i];
			counts[num] = counts[num] ? counts[num] + 1 : 1;
		}

		return counts;
	}

	/**
	 * calculate factorial in range 0...20 via memoization
	 * iterative or table look-up methods had longer runtimes on average
	 * @see {@link http://jsperf.com/word-fact/3|jsPerf}
	 * @param {integer} n - input integer
	 * @return {integer} calculated factorial
	 */
	function factorial(n) {
		var f = [];

		function fact(n) {
			if (n === 0 || n === 1) { return 1; }
			if (f[n] > 0) { return f[n]; }
			return (f[n] = factorial(n - 1) * n);
		}

		return fact(n);
	}

	/**
	 * compute the number possible permutations of a string's characters with a fixed start
	 * @param {string} start - unique character
	 * @param {array} counts - object of each character with their frequencies
	 * @return {number}
	 */
	function permutations(start, counts) {
		var total = 0;
		var repetitions = 1;
		var current = 0;

		for (var chr in counts) {
			current = (chr === start) ? counts[chr] - 1 : counts[chr];
			total += current;
			repetitions *= factorial(current);
		}

		return factorial(total) / repetitions;
	}
}

// find the word position of an example string
(new WordPosition('CAB')).init();