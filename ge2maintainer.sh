#!/bin/sh -efu

#
# Send patch series to the registered maintainers in Cc list
# Usage:
#	$PROG [options] [`get_maintainer.pl` options] <commit> [`git send-email` options]
# Options:
#  --version VERSION	the version of the series (default 1)
#  --count NUM		how many changes to send (default 1)
#
# Author: Andy Shevchenko <andy.shevchenko@gmail.com>
# SPDX-License-Identifier:	GPL-2.0+
#

count="1"
version="1"
options=""
while [ $# -gt 1 ]; do
	case $1 in
		-c|--count) shift; count="$1";;
		-v|--version) shift; version="$1";;
		--) shift; break;;
		--*) options="$options $1";;
		*) break;;
	esac
	shift
done

[ $# -ge 1 ] || exit 1
COMMIT="$1"; shift

OPTS="--no-roles --no-rolestats --remove-duplicates --git --git-min-percent=67 $options"

to=$(git show -$count "$COMMIT" | scripts/get_maintainer.pl $OPTS --no-m --no-r | tr '\n' ',')
cc=$(git show -$count "$COMMIT" | scripts/get_maintainer.pl $OPTS --no-l | tr '\n' ',')

git send-email -M -C -v$version -n$count --to="$to" --cc="$cc" "$@" "$COMMIT"
