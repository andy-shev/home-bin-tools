#!/bin/sh

#
# Show top 25 contributors by changes in the tree.
# Usage:
#	$PROG [options] [revision range]
# Options:
#  --count NUM		how many contributors to show at most
#
# Author: Andy Shevchenko <andy.shevchenko@gmail.com>
# SPDX-License-Identifier:	GPL-2.0+
#

count=25
revision="origin/master..next/master"

while [ $# -ge 1 ]; do
	case $1 in
		--count) shift; count="$1";;
		--) shift; break;;
		*) revision="$1";;
	esac
	shift
done
git shortlog -n --no-merges "$revision" | grep '^[^ ]' | head -n "$count"
