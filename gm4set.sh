#!/bin/sh

#
# Prepare a list of maintainers and mailing list for patches in local tree.
# Usage:
#	$PROG <count> [hash of last commit in the series]
#
# Author: Andy Shevchenko <andy.shevchenko@gmail.com>
# SPDX-License-Identifier:	GPL-2.0+
#

[ $# -lt 1 ] && exit 1
count="$1"; shift
start="$1"; shift

i=1
git log --pretty='%h %f' -n$count --reverse $start | while read c f; do
	f="$(printf '%04d-M-%s' $i $f)"
	echo "Processing $f..."
	git show $c | scripts/get_maintainer.pl --git-min-percent=67 > $f
	i=$((i+1))
done
