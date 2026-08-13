#!/bin/sh
# yaml-format.sh — YAML fallback formatter for opencode.
# Formats .yaml/.yml with yamlfmt ONLY when the project has no biome config
# and no prettier (package.json dependency). Mirrors the natives' findUp:
# walks up from the project root to / so workspace/monorepo ancestors count.
# Usage: yaml-format.sh <file>
# Uses an explicit config next to this script that
# keeps merge keys (drop_merge_tag: true) and preserves the author's
# proportional style (retain_line_breaks: true). No temporary config files
# are written during runtime.
file="$1"
[ -z "$file" ] && exit 0
command -v yamlfmt >/dev/null 2>&1 || exit 0

dir=$(pwd)
while [ "$dir" != "/" ]; do
	[ -f "$dir/biome.json" ] && exit 0
	[ -f "$dir/biome.jsonc" ] && exit 0
	if [ -f "$dir/package.json" ]; then
		# Reliable JSON check: prettier must be declared under one of the four
		# dependency sections. jq is preferred; grep is a best-effort fallback
		# for hosts without jq.
		if command -v jq >/dev/null 2>&1; then
			if jq -e '(.dependencies // {} | has("prettier")) or (.devDependencies // {} | has("prettier")) or (.optionalDependencies // {} | has("prettier")) or (.peerDependencies // {} | has("prettier"))' "$dir/package.json" >/dev/null 2>&1; then
				exit 0
			fi
		elif grep -q '"prettier"[[:space:]]*:' "$dir/package.json"; then
			exit 0
		fi
	fi
	dir=$(dirname "$dir")
done

yamlfmt -conf "$(dirname "$0")/yamlfmt.yaml" "$file"
