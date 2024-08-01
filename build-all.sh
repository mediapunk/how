#!/usr/bin/env bash

shopt -s nullglob # empty array of the following glob returns nothing

FILES=(./content/*.md)

for FILE in "${FILES[@]}"; do
   ./build-page.sh _tmp "$FILE"
done
