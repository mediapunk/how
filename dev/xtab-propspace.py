#!/usr/bin/env python3

#from datetime import datetime
#from datetime import timedelta

import argparse
#import hashlib
#mport json
#import logging
#import math
import os
#import pprint
#import subprocess
import sys
#import time
from pathlib import Path

import re  # https://docs.python.org/3/library/re.html

backslash="\\"
visual_tab = f"——  "  # ——  ––  --
visual_space = "·"

def visualize(line):
    line = re.sub(r" ", visual_space, line)
    line = re.sub(r"\t", visual_tab, line)
    return line


def xtabs(line):
    return re.sub(r"\t","    ",line)

global previous_start
# = None

def processline(line):
    global previous_start

    #previous_start = None

    gutter = None

    # first fix any lines that have mixed tabs and spaces
    if re.search(r"^\t+ ", line):
        line = xtabs(line)
        gutter="[/]"
    if re.search(r"^ +\t", line):
        line = xtabs(line)
        gutter="[/]"

    this_start = None

    starts_with_space=r"^ "
    match = re.search(starts_with_space, line)
    if match:
        if not gutter: gutter = "[ ]"
        this_start = "S"

    starts_with_tab=r"^\t"
    match = re.search(starts_with_tab, line)
    if match:
        if not gutter: gutter = "[-]"
        this_start = "T"

    replace_tabs = False

    if this_start == "T" and previous_start == "S":
        line = xtabs(line)

    previous_start = this_start

    if not gutter: gutter = "   "

    return gutter, line


def get_changed_lines(intext, outtext, args):
    changed_lines = []
    for linenum, mod in enumerate(outtext):
        line = intext[linenum]
        if mod != line:
            changed_lines.append(linenum)
            if args.verbose:
                print(f"DIFF LINE {linenum+1}:")
                print(f"{line}")
                print(f"{mod}")
    return changed_lines

def get_contiguous_ranges(ms):
    grouped = [(i-1 in ms) for i in ms]
    groups = []
    group = []

    for line, gr in zip(ms, grouped):
        if gr:
            group.append(line)
        else:
            if len(group) > 0:
                groups.append(group)
            group = [line]
        
    if len(group) > 0:
        groups.append(group)
    
    return groups


if __name__ == "__main__":
    #here = os.path.abspath(os.path.dirname(__file__))
    #base_name = os.path.basename(__file__).split('.')[0]
    wdir = "." # here
    wdir = os.getcwd()

    parser = argparse.ArgumentParser(description="xtab remove tabs before and after a line")
    parser.add_argument("-v", "--verbose", action="store_true",
        help="print additional messages")

    parser.add_argument("-x", "--exit", action="store_true",
        help="exit early after test code completes")

    parser.add_argument('filename') 

    args = parser.parse_args()


    print(f"file: {args.filename}")

    global previous_start
    previous_start = None

    output = []

    with open(args.filename,"r") as f:
        input = []
        for line in f.readlines():
            line = line.rstrip()
            input.append(line)
            output.append(line)

        previous_start = None
        for linenum, line in enumerate(output):
            gutter, mod = processline(line)
            output[linenum] = mod
            if args.verbose:
                print(rf"FORWARD: {linenum+1:>4}   {gutter} {visualize(mod)}")

        previous_start = None
        for linenum, line in reversed(list(enumerate(output))):
            gutter, mod = processline(line)
            output[linenum] = mod
            if args.verbose:
                print(rf"BACKWARD: {linenum+1:>4}   {gutter} {visualize(mod)}")

        changedlines = get_changed_lines(input, output, args)
        groups = get_contiguous_ranges(changedlines)
        for group in groups:
            print("--")
            for linenum in group:
                c = input[linenum]
                print(f"{linenum+1}  ---  {visualize(c)}")
            for linenum in group:
                c = output[linenum]
                print(f"{linenum+1}  +++  {visualize(c)}")
            print("")

    with open(args.filename,"w") as f:
        for line in output:
            f.write(f"{line}\n")



