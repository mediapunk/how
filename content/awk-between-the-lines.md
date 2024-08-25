---
Title: Awk Between the Lines
---

# Using `awk` to Print Every Line Between Two Patterns

Given two regex patterns, `P1` and `P2`, how do we output all of the lines in a file between the patterns? 

We're going to use awk to create a state machine with two states: "silent state" and "echo state".

Let's start with some assumptions:

- We start in silent state.
- If we match P1, we will switch to echo state.
- If we match P2, we will switch to silent state.
- Reaching the end of the file also forces us to silent state.

One question is about whether matches of P1 and P2 themselves should be included or excluded from the output. We'll borrow some interval notation and say
- square brackets `[` and `]` indicate inclusion;
- round brackets `(` and `)` indicate exclusion.

Another question would be what to do if a single line matches both P1 and P2. When we're all done handling that line, is there a tie-breaker rule that determines which state wins?

## [P1, P2] with ties going silent


    awk "/$P1/{a=1} a; /$P2/{a=0}"

If exactly one line matches P1, and it also matches P2, then that single line will be printed.
You might be asking, does that really work? I don't know. I think it might, but I haven't tested it recently.

Test results: `¯\_(ツ)_/¯`


## [P1, P2) with ties going silent

    awk "{if(f && /$P2/){ exit }}  /$P1/{f=1} f"

    awk "f&&/$P2/{ exit }  /$P1/{f=1} f"

Here's how this awk program works:

- / / is a matching operator, resulting in a boolean value, true or false. 
- f is initially zero (false)
- && is a logical and operator so f&&/$P2/ evaluates to a boolean value
- if f&&/$P2/ is true, then awk executes the code in { }

