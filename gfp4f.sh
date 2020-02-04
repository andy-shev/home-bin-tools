#!/bin/bash

#
# Create sparse patch series based on presence of given file in the changes.
# Usage:
#	$PROG [options] -- <list of files in repository to consider>
# Options:
#  --branch REVISION	the last commit to take into account
#  --count NUM		how many changes to get
#
# Author: Andy Shevchenko <andy.shevchenko@gmail.com>
# SPDX-License-Identifier:	GPL-2.0+
#

count="-1"
branch=

while [ $# -gt 1 ]; do
	case $1 in
		--count) shift; count="$1";;
		--branch) shift; branch="$1";;
		--) shift; break;;
	esac
	shift
done

# To get full diff: git log --full-diff -p -- "$@"

commits=$(git log -n $count --reverse --pretty="format:%H" ${branch} -- "$@")

x=1
for i in $commits; do
	git format-patch --start-number $x $i^..$i
	x=$((x+1))
done
