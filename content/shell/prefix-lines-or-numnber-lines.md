# Adding a Line Number or a Prefix to a line

## Adding Line Numbers

If you  have a file, and simply want to add the line numbers, use cat -n:

    cat -n <file>

If you need to use stdin, nl can do this, and has more options for controlling the line numbering.
To mimic cat -n using stdin, use `nl -ba` (man nl implies that -ba stands for "body: all"

    | nl -ba

Check the man page for details on how to control the witdh, format, and separator

    | nl -ba -s <separator> -w <width> -n <format:ln|rn|rz>



## Prefix with no numbers

Use the nl option -bn "body: none" with a separator as the prefix. The width must be at least one, and nl adds an extra space.

    ... | nl -ba -s'| ' -nrz -w 3 | nl -bn -w1 -s' '

    ... | nl -bn -s "| " -w1 

A more direct approach might be with sed

    ... | sed 's~^~prefix:~'

