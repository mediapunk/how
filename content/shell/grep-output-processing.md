


Using macOS Launch Services to find registered services.
Utility: lsservices

    LAUNCH_SERVICES="/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A"
    LSREGISTER="$LAUNCH_SERVICES/Support/lsregister"

Maybe lsservices has a way to filter its output, but we're interested in how we can process grep output to do that job. Using the `-dump` flag, we get over 100,000 lines of output from lsregister:

    "$LSREGISTER" -dump | wc -l
>     166078

If we want to find lines containing "Google Chrome.app", we can try this:

    "$LSREGISTER" -dump | grep -F "Google Chrome.app"
>     path:                       /private/var/folders/l7/zp30xsg52k96szqv8lw52c3m0000gn/.../Google Chrome.app (0x17e0)
>     path:                       /Applications/Google Chrome.app/Contents/Frameworks/.../Helpers/Google Chrome Helper (Alerts).app (0x1890)
>     ...
>     path:                       /Applications/Google Chrome.app (0x18c8)

     | tr "\n" "\0" | xargs -0 printf "%s\n" | awk '{printf "%s:%s\n",length,$0}' - | sort -n | cut -d':' -f3
