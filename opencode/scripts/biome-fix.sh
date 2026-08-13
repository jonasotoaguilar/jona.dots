#!/bin/sh
# biome-fix.sh — auto-fix biome formatting + safe lint fixes for opencode.
# Runs `biome check --write` on the edited file ONLY when the project has a
# biome config (biome.json/biome.jsonc), mirroring the natives' findUp:
# walks up from the project root to / so workspace/monorepo ancestors count.
# Projects without biome are left untouched.
# Usage: biome-fix.sh <file>
file="$1"
[ -z "$file" ] && exit 0
command -v biome >/dev/null 2>&1 || exit 0

dir=$(pwd)
while [ "$dir" != "/" ]; do
	if [ -f "$dir/biome.json" ] || [ -f "$dir/biome.jsonc" ]; then
		exec biome check --write "$file"
	fi
	dir=$(dirname "$dir")
done
