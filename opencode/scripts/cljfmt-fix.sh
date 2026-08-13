#!/bin/sh
# cljfmt-fix.sh — auto-fix Clojure formatting for opencode.
# Runs `cljfmt fix` on the edited file when the cljfmt binary is available.
# Mirrors the native behavior (binary check only): .clj/.cljs/.cljc/.edn
# files only exist in Clojure projects, so no config gate is needed.
# Usage: cljfmt-fix.sh <file>
file="$1"
[ -z "$file" ] && exit 0
command -v cljfmt >/dev/null 2>&1 || exit 0

exec cljfmt fix --quiet "$file"
