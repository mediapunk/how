#!/usr/bin/env bash
set -e

echo "watching $@"

if ! type fswatch > /dev/null; then
  brew install fswatch
else
  fswatch --version | head -n1
fi

date

function chrome_reload () {
  #printf "$1:   reloading chrome\n"
  osascript -e 'tell application "Google Chrome" to tell the active tab of its first window to reload'
}
export -f chrome_reload

function on_watch() {
  printf " ** change in $1\n"
  chrome_reload
}
export -f on_watch

fswatch -l 0.2 -0 "$@" | xargs -0 -n1 -I{} bash -c '$(echo on_watch "{}")'
#  printf "  modified: {}\n" && $(on_watch)