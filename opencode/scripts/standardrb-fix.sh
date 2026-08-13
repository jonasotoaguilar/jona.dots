#!/bin/sh
# standardrb-fix.sh — auto-fix Ruby lint for opencode.
# Runs `standardrb --fix` on the edited file ONLY when the project uses
# standard (standard.yml or Gemfile with the standard gem). Mirrors the
# natives' findUp: walks up from the project root to / so workspace/monorepo
# ancestors count. Other projects are left untouched.
# Usage: standardrb-fix.sh <file>
file="$1"
[ -z "$file" ] && exit 0
command -v standardrb >/dev/null 2>&1 || exit 0

dir=$(pwd)
while [ "$dir" != "/" ]; do
	[ -f "$dir/standard.yml" ] && exec standardrb --fix "$file"
	if [ -f "$dir/Gemfile" ] && grep -q '^[[:space:]]*gem .standard' "$dir/Gemfile"; then
		exec standardrb --fix "$file"
	fi
	dir=$(dirname "$dir")
done
