#!/usr/bin/env bash

sed -i -E 's/[[:blank:]]+$/_x_/g' "$1"