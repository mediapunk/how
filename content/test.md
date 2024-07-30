---
title: MPNK How
date: July 28, 2024
headline: "CSS Test"
css-path: ./css/custom.css
---



### The `<h3>` Section: Lists

- [Human Quotes](#human-quotes)
- Block Quotes
- Code



#### The `<h4>` Section
This section header uses the `<h4>` element

### Human Quotes

> The only reason for time is so that everything doesn't happen at once.
> —Albert Einstein

---

> Why can't I just eat my waffle?
>  —Barack Obama

### Backticks to Create Type

Using backticks and a string ```` ```x ```` to create a `<pre class="x">` element. Here we make a ```` ```file ```` type.

Create a file called `requirements.txt` with this content:

[requirements.txt]()
```file
jinja2 == 3.1.4
scons == 7.1
```


Today I logged in to an older machine, and tried to clone one of my repos from GitHub.
I got an unusual warning message about the fingerprint that helps identify the host.

>     @    WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!     @
>     @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
>     IT IS POSSIBLE THAT SOMEONE IS DOING SOMETHING NASTY!
>     Someone could be eavesdropping on you right now (man-in-the-middle attack)!


Checking with GitHub, I see that the fingerprint shown is correct, so I need to fix my ~/.ssh/known_hosts file.

I'll search my known_hosts file for "github" and use `-i` to make the search case insensitive.

    cat ~/.ssh/known_hosts | grep -i "github" | tail -c 16
>     ap43JXiUFFAaQ==

The `tail -c 16` writes out just the tail end of the fingerprint for any hits.
Since the known_hosts file can list fingerprints using either a host name or an IP address,
I should probably search for every line that has the same ending. I also use `cut` to get just the the host or IP address.

    cat ~/.ssh/known_hosts | grep "ap43JXiUFFAaQ==" | cut -w -f1
>     github.com,192.30.255.112
>     192.30.255.113
>     140.82.112.3

It turns out I have three entries that match, so I issue three command to remove hosts using `keygen -R`:

    ssh-keygen -R 'github.com'
    ssh-keygen -R '192.30.255.113'
    ssh-keygen -R '140.82.112.3'






# Foot Notes

    sw_vers | grep "Product" | sed -E 's/^.*:\t*(.*)/\1 /' | tr -d '\n'
    $SHELL --version
>     macOS 14.5 
>     zsh 5.9 (x86_64-apple-darwin23.0)

### Generated HTML with

    MD2HTML=( --standalone --template template.html -f gfm )
    FILE="ssh-clean-up.md"; pandoc ${MD2HTML} $FILE -o $FILE.html






