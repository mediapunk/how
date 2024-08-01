#!/usr/bin/env bash

FIN=$1
EXT=".md"
set -e
./check-ext.sh "$EXT" "$FIN"

FOUT="${FIN%%$EXT}.html"

ARGS=(--standalone --template templates/template.html -f gfm)

set -x
pandoc ${ARGS[@]} "$FIN" -o "$FOUT"