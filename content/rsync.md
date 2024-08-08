---
title: Notes on Rsync
date: Aug 2, 2024
css-path: css/custom.css
---

nmap -p 20 192.168.54.22

`rsync`[^rsync]

Only copy over *.h files, skipping any excluded directories
Read the includes/excludes from right to left
copy everything --include="*"
oh yeah but --exclude=".git" 
oh and --exclude="*.*" all the files
except do --include="*.txt" txt files

    rsync -av --include="*.h" --exclude="*.*" --exclude="Debug" --exclude=".git" --include="*" "." keith@192.168.54.26:win03/ --dry-run


    rsync -av --include="*.bat" --exclude="*.*" hubu:titan/script . --dry-run


    rsync -av --exclude="cocdsp-bss-titan" --exclude="BssTitan" --exclude="profw-dsp" --exclude="prodsp-gui" --exclude=".git" --exclude="Release" --exclude="Debug" --include="*.py" hubu:titan/ . --dry-run


    rsync -av --include="*.py" --exclude="*" hubu:titan/ . --dry-run

## Copy all `*.sh` files

Copy every *.sh file, and leave its directory heirarchy intact:

    rsync -amv --include="*/" --include="**/*.sh" --exclude="*" <src>/ <dst>/ --dry-run

| Filter                | Effect                   |
|:-                     |:-                        |
| `--include="*/"`      | First, we will consider every directory |
| `--include="**/*.sh"` | Second, if it ends in .sh, include it   |
| `--exclude="*"`       | Finally, exclude everyting else         |

## Exclude directories, all `*.sh` files

    EXS=("*build" "*[Tt]itan")
    EXA=($(printf "--exclude=%s/** " $EXS))
    rsync -amv --include="*/" $EXA --include="*.sh" --exclude="*" <src>/ <dst>/ --dry-run


## Include multiple extensions

    INS=(".sh" ".py" ".md" ".*workspace*" ".json" ".*project")
    INA=($(printf "--include=*%s " $INS))
    rsync -amv --include="*/" $EXA $INA --exclude="*" <src>/ <dst>/ --dry-run










    rsync -amv --include="**/*.sh" --exclude="**/*.*" --exclude-from= <<< "$EXS" --exclude="src" ./win05/ ./winnew/ -n


## Useful Flags

Looking at the help for rsync[^man], I find these useful flags:

#### Archive Mode
>     -a    archive mode; same as -rlptgoD (no -H)
>
>     -r    recurse into directories
>     -l    copy sym(l)inks as sym(l)inks
>     -p    preserve permissions
>     -t    preserve times
>     -g    preserve group
>     -o    preserve owner (super-user only)
>     -D    preserve device files (super-user only) and special files

#### Prune Empty Directories
>     -m    prune e(m)pty directory chains from file-list

#### Include or Exclude Files
>        --exclude=PATTERN      exclude files matching PATTERN
>        --exclude-from=FILE    read exclude patterns from FILE
>        --include=PATTERN      don't exclude files matching PATTERN
>        --include-from=FILE    read include patterns from FILE
>        --files-from=FILE      read list of source-file names from FILE


Rsync does the following:
- Builds an ordered list of include/exclude patterns as specified on the command-line
- Checks each file name to be transferred against the list of patterns in turn, and the first matching pattern is acted on.
    - If it is an exclude pattern, then that file is skipped
    - If it is an include pattern then that filename is not skipped
    - if no matching pattern is found, then the filename is not skipped


if the pattern starts with a / then it is anchored to a
              particular spot in the hierarchy of files
An unqualified "foo" would match any file or
              directory named "foo" anywhere
              Even the unanchored "sub/foo" would match at any point in the
              hierarchy where a "foo" was found within a directory named
              "sub"

              if the pattern ends with a / then it will only match a
              directory

a '*' matches any non-empty path component (it stops at
              slashes)
use '**' to match anything, including slashes.
a '?' matches any character except a slash (/).

a trailing "dir_name/***" will match both the directory (as if
              "dir_name/" had been specified)

              The combination of "+ */", "+ *.c", and "- *" would include all
              directories and C source files but nothing else (see also the
              --prune-empty-dirs option)

>        --size-only            skip files that match in size [regardless of their modification times]
>        --modify-window=NUM    compare mod-times with reduced accuracy
>        --max-size=SIZE        don't transfer any file larger than SIZE

    rsync -vam --include="**/*.md" --exclude="**/*.*" hubu:titan/ .



[^man]: `man rsync` (macOS 14.5 Sonoma)
[^rsync]: rsync, version 2.6.9, protocol version 29, http://rsync.samba.org

