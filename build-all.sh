#!/usr/bin/env bash

shopt -s nullglob # empty array of the following glob returns nothing
arr=(./content/*.md)

for f in "${arr[@]}"; do
   ./build-page.sh "$f"
done
