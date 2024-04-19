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
tld="$(git rev-parse --show-toplevel)"

git status --porcelain=1 | while read status file1 sep file2; do
	action=""
	case $status in
		M*) action="updated" ;;
		A*) action="added" ;;
		D) action="deleted" ;;
		R*) action="renamed" ;;
		C*) action="copied" ;;
	esac
	shortmsg="$file1 ($action): $message"
	if [ -n "$file2" ]; then
		f1=$(realpath "$tld/$file1" --relative-to="$PWD")
		f2=$(realpath "$tld/$file2" --relative-to="$PWD")
		git commit -s -m "$shortmsg" -- $f1 $f2
	else
		f1=$(realpath "$tld/$file1" --relative-to="$PWD")
		git commit -s -m "$shortmsg" -- $f1
	fi
done
