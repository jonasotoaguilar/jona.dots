#!/bin/sh
# ktlint-fix.sh — auto-fix Kotlin lint + format for opencode.
# Runs `ktlint -F` on the edited file when the ktlint binary is available.
# Mirrors the native behavior (binary check only): .kt/.kts files only exist
# in Kotlin projects, so no config gate is needed.
# Usage: ktlint-fix.sh <file>
file="$1"
[ -z "$file" ] && exit 0
command -v ktlint >/dev/null 2>&1 || exit 0

exec ktlint -F "$file"
