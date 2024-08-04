#!/usr/bin/env bash

shopt -s nullglob # empty array of the following glob returns nothing

FILES=(./content/*.md)

OUTDIR="_tmp"

for FILE in "${FILES[@]}"; do
   ./build-page.sh "$OUTDIR" "$FILE"
done

mkdir -p "$OUTDIR/content/css"

cp -r ./content/css/*.css "$OUTDIR/content/css/"
