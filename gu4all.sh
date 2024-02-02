#!/bin/sh -efu

#
# Update all branches based on the given branch.
# Usage:
#	$PROG [options] [--] [remote/base [local [branch]]]
#
# Author: Andy Shevchenko <andy.shevchenko@gmail.com>
# SPDX-License-Identifier:	GPL-2.0+
#

REMOTE_BASE="next/master"
LOCAL="andy"
BRANCH="netboot-next"

base_only=
by_branch=
by_tag=
while [ "$#" -gt "1" ]; do
	case "$1" in
		--base-only) base_only=1 ;;
		--by-branch) by_branch=1; by_tag= ;;
		--by-tag) by_branch= ; by_tag=1 ;;
		--) shift; break ;;
		*) break ;;
	esac
	shift
done

[ "$#" -ge "1" ] && {
	REMOTE_BASE="$1"; shift
}

[ "$#" -ge "1" ] && {
	LOCAL="$1"; shift
}

[ "$#" -ge "1" ] && {
	BRANCH="$1"; shift
}

are_bases_equal() {
	local base1="$1"; shift
	local base2="$1"; shift

	local base1_hash=$(git rev-parse --verify -q "$base1")
	local base2_hash=$(git rev-parse --verify -q "$base2")

	if [ "$base1_hash" = "$base2_hash" ]; then
		echo "Nothing to update, because $base1 is equal to $base2."
		return 0
	fi
	return 1
}

do_update() {
	local newbase="$1"; shift
	local oldbase="$1"; shift
	local branch="$1"; shift

	# Only for the patched Git that doesn't bail out on the checked out branch
	git rebase --rebase-merges -X ours --onto "$newbase" "$oldbase" "$branch"

	# Workaround for the above issue, not good performance wise
	#git checkout --ignore-other-worktrees "$branch"
	#git rebase --rebase-merges -X ours --onto "$newbase" "$oldbase"
}

# update_base_by_branch(base, local, branch)
update_base_by_branch() {
	local base="$1"; shift
	local local="$1"; shift
	local branch="$1"; shift

	are_bases_equal "$base" "$local/$base" && return

	if git merge-base --is-ancestor "$base" "$branch"; then
		if git merge-base --is-ancestor "$local/$base" "$branch"; then
			echo "Branch $branch was reset to the previous state"
		else
			echo "Branch $branch is already updated"
			return
		fi
	fi
	do_update "$base" "$local/$base" "$branch"
}

# update_base_by_tag(remote_base, local, branch)
update_base_by_tag() {
	local remote_base="$1"; shift
	local local="$1"; shift
	local branch="$1"; shift

	local old_tag=$(git describe --tags --abbrev=0 "$local/$branch")
	local cur_tag=$(git describe --tags --abbrev=0 "$branch")
	local new_tag=$(git describe --tags --abbrev=0 "$remote_base")

	are_bases_equal "$new_tag" "$old_tag" && return

	# Use if-then-fi to prevent script exit on false condition
	if [ "$cur_tag" = "$old_tag" ]; then
		do_update "$new_tag" "$old_tag" "$branch"
	fi
}

# update_branches(local, branch)
update_branches() {
	local local="$1"; shift
	local branch="$1"; shift

	are_bases_equal "$branch" "$local/$branch" && return

	for b in $(git branch --contains "$local/$branch" | cut -c3- | grep -v "^$branch$"); do
		do_update "$branch" "$local/$branch" "$b"
	done
}

if [ -n "$by_branch" ]; then
	update_base_by_branch "$REMOTE_BASE" "$LOCAL" "$BRANCH"
elif [ -n "$by_tag" ]; then
	update_base_by_tag "$REMOTE_BASE" "$LOCAL" "$BRANCH"
fi

[ -n "$base_only" ] && exit 0

update_branches "$LOCAL" "$BRANCH"
