---
title: "Get the Xcode Derived Data Directory"
date: July 27, 2024
css-path: css/custom.css
---

## Default Location

If the user has not customized the location of the derived data, then it is in the default directory

    DEFAULT="$HOME/Library/Developer/Xcode/DerivedData/"

## Custom Location

If the user has cistomized the location, then that location can be read from a plist

    PLIST="com.apple.dt.Xcode.plist"
    PROP="IDECustomDerivedDataLocation"
    defaults read $PLIST $PROP

This call to `defaults` will give a non-zero exit code if the user has not in fact set a custom location

## Either

To gracefullt get the custom location, or the default try this

    defaults read $PLIST $PROP 2>/dev/null || echo "$DEFAULT"
