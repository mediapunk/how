#!/usr/bin/env bash
pandoc --version | head -1

shopt -s nullglob # set glob behavior to give an empty array when there are no matches
FILES=(./content/*.md)

OUTDIR="_tmp"

for FILE in "${FILES[@]}"; do
   ./build-page.sh "$OUTDIR" "$FILE"
done

mkdir -p "$OUTDIR/content/css"

set -x
cp -r ./content/css/*.css "$OUTDIR/content/css/"
set +x

echo "done with $0"