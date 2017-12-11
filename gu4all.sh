#!/bin/sh -efu

#
# Update all branches based on the given branch.
# Usage:
#	$PROG [remote/base [local [branch]]]
#
# Author: Andy Shevchenko <andy.shevchenko@gmail.com>
# SPDX-License-Identifier:	GPL-2.0+
#

REMOTE_BASE="next/master"
LOCAL="andy"
BRANCH="netboot-next"

[ "$#" -ge "1" ] && {
	REMOTE_BASE="$1"; shift
}

[ "$#" -ge "1" ] && {
	LOCAL="$1"; shift
}

[ "$#" -ge "1" ] && {
	BRANCH="$1"; shift
}

# update_base(remote_base, local, branch)
update_base() {
	local remote_base="$1"; shift
	local local="$1"; shift
	local branch="$1"; shift

	local old_tag=$(git describe --tags --abbrev=0 "$local/$branch")
	local cur_tag=$(git describe --tags --abbrev=0 "$branch")
	local new_tag=$(git describe --tags --abbrev=0 "$remote_base")

	# Use if-then-fi to prevent script exit on false condition
	if [ "$cur_tag" = "$old_tag" ]; then
		git rebase --onto "$new_tag" "$old_tag" "$branch"
	fi
}

# update_branches(local, branch)
update_branches() {
	local local="$1"; shift
	local branch="$1"; shift

	for b in $(git branch --contains "$local/$branch" | cut -c3- | grep -v "$branch"); do
		git rebase --onto "$branch" "$local/$branch" "$b"
	done
}

update_base "$REMOTE_BASE" "$LOCAL" "$BRANCH"
update_branches "$LOCAL" "$BRANCH"

# Push updated base back to local
git push -f "$LOCAL" "$BRANCH"
