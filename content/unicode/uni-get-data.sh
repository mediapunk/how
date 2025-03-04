#!/usr/bin/env zsh

VER="16"
DIR="unicode${VER}"

mkdir $DIR || { echo "Directory ${DIR} already exists"; exit }
cd $DIR

URL="https://www.unicode.org/Public/${VER}.0.0/ucd/UCD.zip"
CURL=(curl -s -l "$URL")

printf "\n $  "; printf "%s " $CURL; printf "\n"
$CURL > ucd.zip


TAR=(tar -xzv -f ucd.zip)
#CHERRYPICK="extracted/DerivedName.txt"
[ ! -z "$CHERRYPICK" ] && TAR+=("$CHERRYPICK")

printf "\n $  "; printf "%s " $TAR; printf "\n"
FILES=$($TAR 2>&1)
FCOUNT=$(echo $FILES | wc -l)

if [ -z "$CHERRYPICK" ]; then
    printf "Extracted $FCOUNT files, including:\n"
    echo "$FILES" | sed 's~^[ x]* ~  ~' | grep -v "Test\." | grep "\.txt" | grep -E "(Data)|(Name)|(Prop)|(Bidi)"
else
    NUMLINES=$(< $CHERRYPICK | wc -l | tr -d ' ')
    echo "$CHERRYPICK   -->  $NUMLINES Lines"
fi


