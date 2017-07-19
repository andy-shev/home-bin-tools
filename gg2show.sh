#!/bin/sh

#
# Find commit(s) by output from `git grep`.
# Usage:
#	$PROG <file>:<line>
#
# Author: Andy Shevchenko <andy.shevchenko@gmail.com>
# SPDX-License-Identifier:	GPL-2.0+
#

[ -z "$1" ] && exit 1

arg="$1"; shift

file=$(echo "$arg" | cut -f1 -d':')
line=$(echo "$arg" | cut -f2 -d':')

[ -z "$line" ] && line="$2"

base="HEAD"
[ "$#" -ge 1 ] && {
	base="$1"
	shift
}

echo "$base -- $file $line"

git show $(git annotate "$base" -- "$file" | grep "${line})" | cut -f1)
