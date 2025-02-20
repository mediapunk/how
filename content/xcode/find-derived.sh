#!/usr/bin/env bash

#- Find the DerivedData/overlay-* directory
DEFAULT="$HOME/Library/Developer/Xcode/DerivedData"
PLIST="com.apple.dt.Xcode.plist"
PROP="IDECustomDerivedDataLocation"

# If PROP doesn't exist-meaning no custom location is set-, then fall back to DEFAULT
DERIVEDDATA=$(defaults read $PLIST $PROP 2>/dev/null || echo "$DEFAULT")
echo "$DERIVEDDATA"


