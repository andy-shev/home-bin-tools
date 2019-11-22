#!/bin/sh

MSG="fixup"
[ -n "$1" ] && {
	MSG="$1"
	shift
}

message="$MSG"

git status --porcelain=1 | while read status file; do
	action=""
	case $status in
		M[\ MD]) action="updated" ;;
		A[\ MD]) action="added" ;;
		D) action="deleted" ;;
		R[\ MD]) action="renamed" ;;
		C[\ MD]) action="copied" ;;
	esac
	git commit -s -m "$file ($action): $message" -- $file
done
