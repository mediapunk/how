

# Find Files that have a leading tab character

    find . -name "*.py" -exec grep -HInE "^ *\t" {} \;

# Replace Leading Tab with Spaces

Replace one tab at the beginning of the line with spaces
since TAB is defined as 4 spaces here. 

    TAB="    "
    sed -i '' -E "s/^( *)(\t)/\1$TAB/g" "$FILE"

You may want to run this more than once

    for i in {1..9}; do sed -i '' -E "s/^( *)(\t)/\1$TAB/g" "$FILE"; done