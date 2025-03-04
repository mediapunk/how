title: Getting macOS Version

You can get your macOS version using sw_vers, but if you want to parse this with a script, take note of the tab character (good old ASCII 0x09) in the output, depicted here with the `␉` character.

    sw_vers | grep "Product"
>     ProductName:␉	␉	macOS
>     ProductVersion:␉␉	14.5

I want to use sed to isolate the version number. I've heard you can just litterally type a tab character into your regex pattern, but that doesn't seem to work for me across all terminals.

I solved it by using ANSI C quoting, available in the shells I use the most zsh and bash. A string like this

    $'...'

will interpret escaped characters, so I can type `\t` and get a tab sent to sed. In this case I also need to use `\\1` to get a `\1` sent to sed.

    sw_vers | grep "Product" | sed -E $'s~^.*:\t*(.*)~\\1 ~' | tr -d '\n'

>     macOS 14.5 

I also tried this command on a much older Mac that I have.

>     Mac OS X 10.15.7 
