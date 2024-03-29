#!/bin/sh

#
# Commit each added/deleted/updated/... file in a separate commit.
# Usage:
#	$PROG ["Commit message payload"] ...
#
# When ["Commit message payload"] is supplied the Subject line will look like:
#	path/to/file (<action>): Commit message payload
# where <action> is one of added/deleted/updated/renamed/copied.
# The body will be left empty.
#
# Author: Andy Shevchenko <andy.shevchenko@gmail.com>
# SPDX-License-Identifier:	GPL-2.0+
#

MSG="fixup"
[ -n "$1" ] && {
	MSG="$1"
	shift
}

message="$MSG"

git status --porcelain=1 | while read status file1 sep file2; do
	action=""
	case $status in
		M*) action="updated" ;;
		A*) action="added" ;;
		D) action="deleted" ;;
		R*) action="renamed" ;;
		C*) action="copied" ;;
	esac
	git commit -s -m "$file1 ($action): $message" -- $file1 $file2
done
