#!/usr/bin/env bash
ROOT=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
echo "Script Root: $ROOT"

pandoc --version | head -1

cd $ROOT/content
CDIR="."


OUTDIR="$ROOT/_site"
mkdir -p "$OUTDIR"


#set -x
INDEX="$OUTDIR/index.md"
cat "$ROOT/templates/index.md" > "$INDEX"

#shopt -s nullglob # set glob behavior to give an empty array when there are no matches

FILES=( $(find . -type f -name "*.md") )
printf -- "<%s>\n" "${FILES[@]}"

for FILE in "${FILES[@]}"; do
    printf -- "\n [ %s ]\n" $FILE
    $ROOT/build-page.sh "$OUTDIR" "$CDIR" "$FILE" "$INDEX"
    printf -- "\n"
done

printf -- "\n [ %s ]\n" "$INDEX"
$ROOT/build-page.sh "$OUTDIR" "$OUTDIR" "$INDEX"
printf -- "\n"
rm "$INDEX"

echo "copying *.css files"
rsync -amv --include="*/" --include="*.css" --exclude="*" "$ROOT/content/" "$OUTDIR/"

echo ""
echo "done with $0"