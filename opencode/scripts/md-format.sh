#!/bin/sh
# md-format.sh — markdown fallback formatter for opencode (Option C).
# Formats .md/.mdx with deno fmt ONLY when the project has no prettier
# (package.json dependency) and no biome config. Mirrors the natives' findUp:
# walks up from the project root to / so workspace/monorepo ancestors count.
# Usage: md-format.sh <file>
# Uses --prose-wrap preserve: prose is left exactly as authored (no reflow
# churn on edit); tables and fenced code blocks are still normalized.
file="$1"
[ -z "$file" ] && exit 0
command -v deno >/dev/null 2>&1 || exit 0

dir=$(pwd)
while [ "$dir" != "/" ]; do
	[ -f "$dir/biome.json" ] && exit 0
	[ -f "$dir/biome.jsonc" ] && exit 0
	if [ -f "$dir/package.json" ] && grep -q '"prettier"[[:space:]]*:' "$dir/package.json"; then
		exit 0
	fi
	dir=$(dirname "$dir")
done

deno fmt --prose-wrap preserve "$file"
