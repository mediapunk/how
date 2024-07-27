---
title: MPNK How
date: July 27, 2024
headline: "SSH Warning: Remote Host Identification Has Changed"
css-pandoc: pandoc-html-style.css
css-custom: custom-html-style.css
---

Today I logged in to an older machine, and tried to clone one of my repos from GitHub. I got this message:

>     @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
>     @    WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!     @
>     @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
>     IT IS POSSIBLE THAT SOMEONE IS DOING SOMETHING NASTY!
>     Someone could be eavesdropping on you right now (man-in-the-middle attack)!
>     It is also possible that a host key has just been changed.
>     The fingerprint for the RSA key sent by the remote host is
>     SHA256:uNiVztksCsDhcc0u9e8BujQXVUpKZIDTMczCvj3tD2s.

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

Now if I count how many matches I have, I see there are none

    cat ~/.ssh/known_hosts | grep "ap43JXiUFFAaQ==" | wc -l
>     0

Now I attempt to clone the repo again, and see if the fingerprint mismatch is solved.

    git clone git@github.com:*****.git
>     Cloning into '*****'...
>     The authenticity of host 'github.com (140.82.116.3)' can't be established.
>     ED25519 key fingerprint is SHA256:+DiY3wvvV6TuJJhbpZisF/zLDA0zPMSvHdkr4UvCOqU.
>     …
>     Permanently added 'github.com' (ED25519) to the list of known hosts.


    cat ~/.ssh/known_hosts | grep -i "github" | tail -c 16
>     WZ2YB/++Tpockg=




#### Foot Notes

    sw_vers | grep "Product" | sed -E 's/^.*:\t*(.*)/\1 /' | tr -d '\n'
    $SHELL --version
>     macOS 14.5 
>     zsh 5.9 (x86_64-apple-darwin23.0)

Generated HTML with

    MD2HTML=( --standalone --template template.html -f gfm )
    FILE="ssh-clean-up.md"; pandoc ${MD2HTML} $FILE -o $FILE.html






