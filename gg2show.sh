#!/bin/sh

#
# Find commit(s) by output from `git grep [commit] -- <file>`.
# Usage:
#	$PROG [commit:]<file>:<line>
#
# Alternative variant:
#	$PROG <file> <commit> <line>
#
# Author: Andy Shevchenko <andy.shevchenko@gmail.com>
# SPDX-License-Identifier:	GPL-2.0+
#

[ -z "$1" ] && exit 1

arg="$1"; shift

a=$(echo "$arg" | cut -f1 -d':')
b=$(echo "$arg" | cut -s -f2 -d':')
c=$(echo "$arg" | cut -s -f3 -d':')

if git rev-parse --verify -q "$a"; then
	base="$a"
	file="$b"
	line="$c"
else
	base="HEAD"
	file="$a"
	line="$b"
fi

[ -z "$line" ] && line="$2"

[ "$#" -ge 1 ] && {
	base="$1"
	shift
}

echo "$base -- $file $line"

git show $(git annotate "$base" -- "$file" | grep "${line})" | cut -f1)
