#!/usr/bin/env bash
ext=$1
file=$2
pattern=$(echo "$ext" | sed -r "s/\./\\\./g")
pattern="$pattern\$"
printf "Checking for extension $1: "
echo ${file} | grep "${pattern}"
RV=$?;
(( RV != 0 )) && echo "[$file]   error: required extension is $ext"
exit $RV