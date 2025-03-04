#!/usr/bin/env python

import sys
import os
from fractions import Fraction
from pathlib import Path


if len(sys.argv) < 2:
    print(f"usage: {0} <parent/dir/for/UnicodeData.txt>")
    sys.exit(1)

class UnicodeEntry:

    def __init__(self, code ,name, cat,
        combo,bidi,decomp,
        decidigit,digit,numeric,
        mirrored,
        v1name,comment,
        uppercase,lowercase,titlecase):
        self.code = int(code,16)
        self.name = name
        self.cat = cat
        self.combo = combo
        self.bidi = bidi
        self.decomp = decomp

        self.decidigit = int(decidigit) if len(decidigit)>0 else None
        self.digit = int(digit) if len(digit)>0 else None
        self.numeric = Fraction(numeric) if len(numeric)>0 else None

        self.mirrored = True if mirrored == 'Y' else False

        if not v1name and "CENTRE" in self.name:
            v1name = ""

        if "CENTRED" in self.name:
            if not "CENTERED" in v1name:
                v1name += " CENTERED"
        elif "CENTRE" in self.name:
            if not "CENTER" in v1name:
                v1name += " CENTER"

        if v1name:
            comps = self.name.split()
            v1comps = v1name.split()

            for c in comps:
                if c in v1comps:
                    v1comps.remove(c)
                    #v1comps.append(f"~{c}~")
            v1name = " ".join(v1comps)
            v1name = f"{v1name}"

        self.v1name = v1name
        self.comment = comment
        self.uppercase = uppercase
        self.lowercase = lowercase
        self.titlecase = titlecase

    def cases(self):
        cmap = {}
        if self.uppercase: cmap['upper'] = self.uppercase
        if self.lowercase: cmap['lower'] = self.lowercase
        if self.titlecase: cmap['title'] = self.titlecase
        return cmap

    def codepoint(self):
        return hex(self.code).lstrip("0x").upper()

    def char(self):
        return chr(self.code) if self.cat[0] != "C" else None





def output_to_devnull():
    # if the output is piped to a utility that closes its stdin (such as `head`)
    # then our stdout gets closed, which is not an error. We need to redirect
    # our output to /dev/null to avoid further exceptions
    devnull = os.open(os.devnull, os.O_WRONLY)
    os.dup2(devnull, sys.stdout.fileno())


def parseline(line: str):
    data=line.strip().split(';')
    e = UnicodeEntry(*data)

    if e.cat[0] == 'C':
        return

    props = [e.cat]
    combo = f"C:{e.combo}" if e.combo and int(e.combo) > 0 else None
    if combo: props.append(f"{combo}")

    otherstr = None

    if e.mirrored:
        other = bidimap.get(e.code, None)
        otherstr = hex(other).lstrip("0x").upper() if other else None
        if otherstr:
            otherstr = f"<M:U+{otherstr}>"
        else:
            otherstr = "<>"

    if otherstr: props.append(otherstr)

    include_bidi = False
    if include_bidi:
        bidi = f"-{e.bidi}-" if e.bidi else None
        if bidi: props.append(f"{bidi:5}")


    propstr = " ".join(props)
    propstr = f"({propstr})"

    aka = f" ({e.v1name})" if e.v1name else ""
    comment = f" *{e.comment})" if e.comment else ""
    text = f"{e.name}{aka}{comment}"

    cases = ", ".join([f"{w}:{x}" for w,x in e.cases().items()])
    cases = f"{{{cases}}}" if cases else ""

    decomp = "+".join(e.decomp.split(' ')) if e.decomp else None
    decomp = f"({decomp})" if decomp else ""

    num = f"(Number = {e.numeric})" if e.numeric != None else ""

    c = e.char()
    if not c: c = " "

    print(f"[U+{e.codepoint():>5}] {propstr:8}    {c}    {text} {num} {decomp} {cases}")


bidimap = {}

try:
    unicode_dir = Path(sys.argv[1])
    unicode_data = unicode_dir/"UnicodeData.txt"
    bidi_mirroring = unicode_dir/"BidiMirroring.txt"

    # Read in the Bidirectional mapping
    with open(bidi_mirroring,'r') as bididata:
        for line in bididata:
            line = line.split("#")[0].strip()
            if line:
                data = line.split(";")
                if len(data) > 1:
                    d0 = int(data[0],16)
                    d1 = int(data[1],16)
                    bidimap[d0] = d1

    # Now process the main file
    with open(unicode_data,'r') as unidata:
        for line in unidata:
            line = line.strip()
            parseline(line)

except BrokenPipeError:
    output_to_devnull()
    
    


