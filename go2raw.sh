#!/bin/sh

#
# Extract object by its hash.
# Usage:
#	$PROG <hash>
#
# Author: Andy Shevchenko <andy.shevchenko@gmail.com>
# SPDX-License-Identifier:	GPL-2.0+
#

IT="$1"
TYPE=$(git cat-file -t $IT)
git cat-file $TYPE $IT > $IT.raw
echo $TYPE
