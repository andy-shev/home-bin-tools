#!/bin/sh

MSG="fixup"
[ -n "$1" ] && {
	MSG="$1"
	shift
}

pattern="^.M "
message="$MSG"

git status --porcelain=1 | sed -e "/$pattern/ s/$pattern//" | while read file; do
	git commit -s -m "$file: $message" $file
done
