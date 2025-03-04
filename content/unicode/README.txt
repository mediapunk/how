

Directory "16" contains a minimal extraction of Unicode 16.0

To get one line of info for every unicode character:

    ./uni-char-process.py 16



To download all the unicode data:

    ./uni-get-data.sh

which puts the data in a directory called unicode16








---------


    while read -u9 L; do IFS=';' read -A D <<< "$L"; printf " %6s; Cat %+3s; Combo %4s; BiDi %4s; Decomp %2s; Mirror %2s\n" ${D[1]} ${D[3,7]} ${D[8,2]}; done 9<UnicodeData.txt | head -50 | tail -30


[https://www.unicode.org/L2/L1999/UnicodeData.html]


    000A;<control>;Cc;0;B;;;;;N;LINE FEED (LF);;;;
    0020;SPACE;Zs;0;WS;;;;;N;;;;;
    0021;EXCLAMATION MARK;Po;0;ON;;;;;N;;;;
    0024;DOLLAR SIGN;Sc;0;ET;;;;;N;;;;;
    0028;LEFT PARENTHESIS;     Ps;  0;  ON;;;;;Y;OPENING PARENTHESIS;;;;
    0029;RIGHT PARENTHESIS;    Pe;  0;  ON;;;;;Y;CLOSING PARENTHESIS;;;;
    0031;DIGIT ONE;Nd;0;EN;;1;1;1;N;;;;;
    20A3;FRENCH FRANC SIGN;Sc;0;ET;;;;;N;;;;;
    2121;TELEPHONE SIGN;So;0;ON;<compat> 0054 0045 004C;;;;N;T E L SYMBOL;;;;
    29B8;CIRCLED REVERSE SOLIDUS;Sm;0;ON;;;;;Y;;;;;
    29C0;CIRCLED LESS-THAN;Sm;0;ON;;;;;Y;;;;;
    29C9;TWO JOINED SQUARES;Sm;0;ON;;;;;Y;;;;;
    2B51;BLACK SMALL STAR;So;0;ON;;;;;N;;;;;
    2B9C;BLACK LEFTWARDS EQUILATERAL ARROWHEAD;So;0;ON;;;;;N;;;;;
    2BE7;POSEIDON;So;0;ON;;;;;N;;;;;
    328A;CIRCLED IDEOGRAPH MOON;So;0;L;<circle> 6708;;;;N;;;;;
    32D5;CIRCLED KATAKANA KA;So;0;L;<circle> 30AB;;;;N;;;;;


Examples of some Bidirectional Categories
 ON Other Neutrals (Follows language direction)
 L  Left-to-Right
 ES European Number Separator (e.g currency symbols)
 B  Paragraph Separator

[https://www.unicode.org/reports/tr9/]

### Normative

Field 0-2: Code value; Character name; General category (normative or informative)
Field 3-5: Canonical combining classes; Bidirectional category; Character decomposition mapping
Field 6-8: Numeric Values: Decimal Digit, Digit, Numeric (e.g. characters for 2,superscript 2, and 1/2)
Field 9:   Mirrored Y/N (e.g. open and close parentheses)

### Informative

Field 10:    Old Unicode 1.0 Name, if different
Field 11:    ISO 10646 comment field
Field 12-14: (Informative):	Uppercase, Lowercase, and Titlecase mappings


## Canonical Combining Classes

Value: Description
0:	Spacing, split, enclosing, reordrant, and Tibetan subjoined
1:	Overlays and interior
7:	Nuktas
8:	Hiragana/Katakana voicing marks
9:	Viramas
10:	Start of fixed position classes
199:	End of fixed position classes
200:	Below left attached
202:	Below attached
204:	Below right attached
208:	Left attached (reordrant around single base character)
210:	Right attached
212:	Above left attached
214:	Above attached
216:	Above right attached
218:	Below left
220:	Below
222:	Below right
224:	Left (reordrant around single base character)
226:	Right
228:	Above left
230:	Above
232:	Above right
233:	Double below
234:	Double above
240:	Below (iota subscript)

Note: some of the combining classes in this list do not currently have members but are specified here for completeness.




Decimal digit value	normative	This is a numeric field. If the character has the decimal digit property, as specified in Chapter 4 of the Unicode Standard, the value of that digit is represented with an integer value in this field
7	Digit value	normative	This is a numeric field. If the character represents a digit, not necessarily a decimal digit, the value is here. This covers digits which do not form decimal radix forms, such as the compatibility superscript digits
8	Numeric value

Field Name Status Explanation
0	Code value	normative	Code value in 4-digit hexadecimal format.
1	Character name	normative	These names match exactly the names published in Chapter 7 of the Unicode Standard, Version 2.0, except for the two additional characters.
2	General category	normative / informative
(see below)	This is a useful breakdown into various "character types" which can be used as a default categorization in implementations. See below for a brief explanation.
3	Canonical combining classes	normative	The classes used for the Canonical Ordering Algorithm in the Unicode Standard. These classes are also printed in Chapter 4 of the Unicode Standard.
4	Bidirectional category	normative	See the list below for an explanation of the abbreviations used in this field. These are the categories required by the Bidirectional Behavior Algorithm in the Unicode Standard. These categories are summarized in Chapter 3 of the Unicode Standard.
5	Character decomposition mapping	normative	In the Unicode Standard, not all of the mappings are full (maximal) decompositions. Recursive application of look-up for decompositions will, in all cases, lead to a maximal decomposition. The decomposition mappings match exactly the decomposition mappings published with the character names in the Unicode Standard.
6	Decimal digit value	normative	This is a numeric field. If the character has the decimal digit property, as specified in Chapter 4 of the Unicode Standard, the value of that digit is represented with an integer value in this field
7	Digit value	normative	This is a numeric field. If the character represents a digit, not necessarily a decimal digit, the value is here. This covers digits which do not form decimal radix forms, such as the compatibility superscript digits
8	Numeric value	normative	This is a numeric field. If the character has the numeric property, as specified in Chapter 4 of the Unicode Standard, the value of that character is represented with an integer or rational number in this field. This includes fractions as, e.g., "1/5" for U+2155 VULGAR FRACTION ONE FIFTH Also included are numerical values for compatibility characters such as circled numbers.
8	Mirrored	normative	If the character has been identified as a "mirrored" character in bidirectional text, this field has the value "Y"; otherwise "N". The list of mirrored characters is also printed in Chapter 4 of the Unicode Standard.
10	Unicode 1.0 Name	informative	This is the old name as published in Unicode 1.0. This name is only provided when it is significantly different from the Unicode 3.0 name for the character.

11	10646 comment field	informative	This is the ISO 10646 comment field. It is in parantheses in the 10646 names list.

12	Uppercase mapping	informative	Upper case equivalent mapping. If a character is part of an alphabet with case distinctions, and has an upper case equivalent, then the upper case equivalent is in this field. See the explanation below on case distinctions. These mappings are always one-to-one, not one-to-many or many-to-one. This field is informative.
13	Lowercase mapping	informative	Similar to Uppercase mapping
14	Titlecase mapping	informative	Similar to Uppercase mapping


General Category

### Normative

    Lu	Letter, Uppercase
    Ll	Letter, Lowercase
    Lt	Letter, Titlecase

    Mn	Mark, Non-Spacing
    Mc	Mark, Spacing Combining
    Me	Mark, Enclosing
    
    Nd	Number, Decimal Digit
    Nl	Number, Letter
    No	Number, Other
    
    Zs	Separator, Space
    Zl	Separator, Line
    Zp	Separator, Paragraph
    
    Cc	Other, Control
    Cf	Other, Format
    Cs	Other, Surrogate
    Co	Other, Private Use
    Cn	Other, Not Assigned (no characters in the file have this property)

### Informative

    Lm	Letter, Modifier
    Lo	Letter, Other
    
    Pc	Punctuation, Connector
    Pd	Punctuation, Dash
    Ps	Punctuation, Start/Open
    Pe	Punctuation, End/Close
    Pi	Punctuation, Initial quote (may behave like Ps or Pe depending on usage)
    Pf	Punctuation, Final quote (may behave like Ps or Pe depending on usage)
    Po	Punctuation, Other
    
    Sm	Symbol, Math
    Sc	Symbol, Currency
    Sk	Symbol, Modifier
    So	Symbol, Other


These can be used to find the non-ASCII equivalent of 'alnum'. Or the opposite thereof.
I use anything except Ll, Lo, Lt, Lu, Mc, Mn, Nd, Nl and Cs as word separators / delimiters.

## Field 5
Character Decomposition Mapping E,S N

<font>	A font variant (e.g. a blackletter form).
<noBreak>	A no-break version of a space or hyphen.
<initial>	An initial presentation form (Arabic).
<medial>	A medial presentation form (Arabic).
<final>	A final presentation form (Arabic).
<isolated>	An isolated presentation form (Arabic).
<circle>	An encircled form.
<super>	A superscript form.
<sub>	A subscript form.
<vertical>	A vertical layout presentation form.
<wide>	A wide (or zenkaku) compatibility character.
<narrow>	A narrow (or hankaku) compatibility character.
<small>	A small variant form (CNS compatibility).
<square>	A CJK squared font variant.
<fraction>	A vulgar fraction form.
<compat>	Otherwise unspecified compatibility character.
    
Compat can be used (among other things) to find ASCII equivalents for non-ASCII glyphs;

Glyph	ASCII
À	A
Ĳ	IJ
ǈ	Lj
Ⅷ	VIII

## Field 6
Decimal digit value E,N N
EG 8 for Ⅷ.

## Field 13
This has some quirks. It applies the lower case mapping to compat as well. For instance, it considers 'OHM SIGN' ('Ω') to be compatible with 'GREEK CAPITAL LETTER OMEGA'. A 'towlower()' will therefore convert 'OHM SIGN' to 'GREEK SMALL LETTER OMEGA' ('ω'). Not the same thing at all.
