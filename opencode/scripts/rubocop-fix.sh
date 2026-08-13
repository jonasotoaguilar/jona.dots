#!/bin/sh
# rubocop-fix.sh — auto-fix Ruby lint for opencode.
# Runs `rubocop --autocorrect` on the edited file ONLY when the project has a
# rubocop config (.rubocop.yml/.rubocop.yaml) and does not use standardrb
# (standard.yml or Gemfile with the standard gem). Mirrors the natives'
# findUp: walks up from the project root to / so workspace/monorepo
# ancestors count. Other projects are left untouched.
# Usage: rubocop-fix.sh <file>
file="$1"
[ -z "$file" ] && exit 0
command -v rubocop >/dev/null 2>&1 || exit 0

dir=$(pwd)
while [ "$dir" != "/" ]; do
	[ -f "$dir/standard.yml" ] && exit 0
	if [ -f "$dir/Gemfile" ] && grep -q '^[[:space:]]*gem .standard' "$dir/Gemfile"; then
		exit 0
	fi
	if [ -f "$dir/.rubocop.yml" ] || [ -f "$dir/.rubocop.yaml" ]; then
		exec rubocop --autocorrect "$file"
	fi
	dir=$(dirname "$dir")
done
