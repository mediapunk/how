---
title: MPNK How
date: July 27, 2024
headline: "Build and Reload"
css-path: css/custom.css
---


# Sublime Build System

Custom build system can be created for Sublime Text by saving a `*.sublime-build` file here

`~/Library/Application Support/Sublime Text[ 3]/Packages/User`

Create one called `Markdown to HTML.sublime-build`
```json
{
  "shell_cmd": "pandoc --standalone --template templates/template.html -f gfm $file -o $file.html",
  "working_dir": "$folder",
  "file_patterns": ["*.md"]
}
```

# Set Up Chrome to Auto Reload

```sh
ARRAY_OF_FILES=( content/*.md.html content/css/*.*ss ... )
ARRAY_OF_FILES=( _tmp/content/* )

./chrome-refresh.sh ${ARRAY_OF_FILES}
```

Or try running the command in the background

```
nohup ./chrome-refresh.sh ${ARRAY_OF_FILES} >> .tmp-chrome-refresh.out 2>&1 &
```

where the contents are

- [ ] `chrome-refresh.sh`
```file
#!/usr/bin/env bash
set -e

echo "watching $@"

if ! type fswatch > /dev/null; then
  brew install fswatch
else
  fswatch --version | head -n1
fi

function chrome_reload () {
  printf "  reloading chrome\n"
  osascript -e 'tell application "Google Chrome" to tell the active tab of its first window to reload'
}
export -f chrome_reload

function on_watch() {
  printf "  on_watch $1\n"
  chrome_reload
}
export -f on_watch

fswatch -l 0.3 -0 "$@" | xargs -0 -n1 -I{} bash -c '$(on_watch "{}")'
#  printf "  modified: {}\n" && $(on_watch)
```