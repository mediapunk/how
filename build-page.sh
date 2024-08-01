#!/usr/bin/env bash

OUTPUT=${1}
mkdir -p "$OUTPUT"

FIN=${2}
EXT=".md"
set -e
"./check-ext.sh" "$EXT" "$FIN"

FOUT="${OUTPUT}/${FIN%%$EXT}.html"
DIR="$(dirname $FOUT)"
mkdir -p "$DIR"

ARGS=(--standalone --template "templates/template.html" -f gfm)

set -x
pandoc ${ARGS[@]} "$FIN" -o "$FOUT"