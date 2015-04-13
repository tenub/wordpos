<?php
class WordPosition
{
	function __construct($string) {
		$time = -microtime(true);

		// ensure the input string follows proper format, otherwise just return false
		if (preg_match('/^[A-Z]{2,20}$/', $string) === 0) { return false; }

		$cur_word_char;
		$cur_uniq_char;
		$word_chars = str_split($string);
		$uniq_chars = $this->getUniqChars($word_chars);
		sort($uniq_chars, SORT_STRING);
		$counts = $this->frequency($word_chars);
		$position = 0;

		// find the word position of all possible combinations of its characters
		while (count($word_chars) > 0) {
			$cur_word_char = array_shift($word_chars);
			$l = count($uniq_chars);
			for ($i = 0; $i < $l; $i++) {
				$cur_uniq_char = $uniq_chars[$i];

				if ($cur_word_char === $cur_uniq_char) {
					$counts[$cur_uniq_char] -= 1;
					if ($counts[$cur_uniq_char] === 0) {
						array_splice($uniq_chars, array_search($cur_word_char, $uniq_chars), 1);
						unset($counts[$cur_word_char]);
					}
					break;
				} else {
					// calculate all possible permutations starting with the current unique character
					$position += $this->permutations($cur_uniq_char, $counts);
				}
			}
		}

		$time += microtime(true);
		echo 'alphabetical position of input string in all possible anagrams: ' . ($position + 1) . ' calculated in ' . sprintf('%f', $time) . ' seconds';
	}

	/**
	 * find the unique characters in an array
	 * @param {array} array - array of characters
	 * @return {array} unique array
	 */
	public function getUniqChars($array) {
		$res = array();

		foreach($array as $key => $val) { $res[$val] = true; }

		return array_keys($res);
	}

	/**
	 * compute the frequency of elements in an array
	 * @param {array} array - array containing elements to count
	 * @return {object} unique character keys with frequency values
	 */
	public function frequency($array) {
		$counts = [];

		$l = count($array);
		foreach ($array as $value) {
			$counts[$value] = isset($counts[$value]) ? $counts[$value] + 1 : 1;
		}

		return $counts;
	}

	/**
	 * calculate factorial in range 0...20 via memoization
	 * iterative or table look-up methods had longer runtimes on average
	 * @see {@link http://jsperf.com/word-fact/3|jsPerf}
	 * @param {integer} n - input integer
	 * @return {integer} calculated factorial
	 */
	public function factorial($n) {
		static $cache = array(1);

		$n = (int) $n;

		if (!isset($cache[$n])) {
			$base = max(array_keys($cache));

			while ($n >= ++$base) {
				$cache[$base] = $base * $this->factorial($base - 1);
			}
		}

		return $cache[$n];
	}

	/**
	 * compute the number possible permutations of a string's characters with a fixed start
	 * @param {string} start - unique character
	 * @param {array} counts - object of each character with their frequencies
	 * @return {number}
	 */
	public function permutations($start, $counts) {
		$total = 0;
		$repetitions = 1;
		$current = 0;

		foreach ($counts as $chr => $count) {
			$current = ($chr === $start) ? $count - 1 : $count;
			$total += $current;
			$repetitions *= $this->factorial($current);
		}

		return $this->factorial($total) / $repetitions;
	}
}

// call the function with an input string
global $argv;
array_shift($argv);
foreach ($argv as $string) {
	new WordPosition($string);
}
?>