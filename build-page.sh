#!/usr/bin/env bash
ROOT=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

OUTPUT=$(readlink -f -- "$1")
INDIR=$(readlink -f -- "$2")
FIN=$(readlink -f -- "$3" )
INDEX=${4}

EXT=".md"
set -e
"$ROOT/check-ext.sh" "$EXT" "$FIN" > /dev/null

#VERBOSE="1"
[ -z $VERBOSE ] || echo "Output Directory: $OUTPUT"
[ -z $VERBOSE ] || echo "Input Directory: $INDIR"
cd "$INDIR"


RELIN=$( echo "$FIN" | sed -e "s:^$INDIR/::" )
[ -z $VERBOSE ] || echo "Input File: $RELIN"

PAGE="${RELIN%%$EXT}.html"
FOUT="${PAGE}"
DIR="$(dirname $FOUT)"
FOUT="$OUTPUT/$PAGE"
echo "Rendering: $FOUT"

if [ -f "$INDEX" ]; then
    [ -z $VERBOSE ] || echo "Adding index link to $PAGE"
    echo " - [$PAGE]($PAGE)" >> "$INDEX"
fi

[ -z $VERBOSE ] || echo "Creating output directory: $OUTPUT/$DIR"
mkdir -p "$OUTPUT/$DIR"

ARGS=()
ARGS+=(--standalone)
ARGS+=(--template "$ROOT/templates/template.html")
ARGS+=(-f gfm)

# Filter to converd md links to html links
#ARGS+=(--lua-filter "$ROOT/fix-md-links.lua")

set -x
pandoc ${ARGS[@]} "$RELIN" -o "$FOUT"