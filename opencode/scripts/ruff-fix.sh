#!/bin/sh
# ruff-fix.sh — auto-fix safe ruff lint issues + format for opencode.
# Runs `ruff check --fix` then `ruff format` on the edited file ONLY when the
# project has a ruff config (ruff.toml/.ruff.toml or pyproject.toml with
# [tool.ruff]), mirroring the natives' findUp: walks up from the project root
# to / so workspace/monorepo ancestors count. Projects without ruff are
# untouched. Keeps the builtin `ruff format` behavior and adds lint fixes.
# Usage: ruff-fix.sh <file>
file="$1"
[ -z "$file" ] && exit 0
command -v ruff >/dev/null 2>&1 || exit 0

dir=$(pwd)
while [ "$dir" != "/" ]; do
	if [ -f "$dir/ruff.toml" ] || [ -f "$dir/.ruff.toml" ] || { [ -f "$dir/pyproject.toml" ] && grep -q '\[tool\.ruff\]' "$dir/pyproject.toml"; }; then
		ruff check --fix "$file" && exec ruff format "$file"
	fi
	dir=$(dirname "$dir")
done
