#!/bin/sh -efu

#
# Give a list of files that contain the given word.
# Usage:
#	$PROG <word> [another word] ...
#  word		word to search
#
# When [another word] is supplied it will be searched for in the files which
# contains [word] from previous search. This will be applied to each word
# in the command line until there will be no more words to consider.
#
# Author: Andy Shevchenko <andy.shevchenko@gmail.com>
# SPDX-License-Identifier:	GPL-2.0+
#

grep_for_func() {
	local func="$1"; shift

	git grep -lw "$func" -- "$@"
}

result=
while [ $# -ge 1 ]; do
	case $1 in
		--) shift; break;;
		*) result=$(grep_for_func "$1" $result);;
	esac
	shift
done

echo "$result"
