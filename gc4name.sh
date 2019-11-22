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
		M*) action="updated" ;;
		A*) action="added" ;;
		D) action="deleted" ;;
		R*) action="renamed" ;;
		C*) action="copied" ;;
	esac
	git commit -s -m "$file ($action): $message" -- $file
done
