#!/usr/bin/env zsh
VOLS=(/Volumes/*(N))
for V in $VOLS; do
    USAGE=( $(df -Plg $V | tail -1 | awk '{print $2, $3, $5}' ) );
    printf " • %-25s (using %3s of %4s GiB)\n" ${V} ${USAGE[3]} ${USAGE[1]};
done
