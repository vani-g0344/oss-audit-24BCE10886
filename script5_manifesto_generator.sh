#!/bin/bash
# =============================================================================
# Script 5: Open Source Manifesto Generator
# Author  : Vani Gupta | 24BCE10886
# =============================================================================

echo "================================================================"
echo "         OPEN SOURCE MANIFESTO GENERATOR                       "
echo "         OSS Audit — Vani Gupta | 24BCE10886                   "
echo "================================================================"
echo ""
echo "  This tool will generate a personalised open source philosophy"
echo "  statement based on your answers to three questions."
echo ""
echo "  Answer honestly — this is your manifesto, your voice."
echo ""

# --- Interactive input section ---
# 'read -p' displays a prompt and waits for the user to type a line.
# The input is stored in the named variable.

# Question 1: A tool the user relies on daily
read -p "  1. Name one open-source tool you use every day: " TOOL
echo ""

# Question 2: What 'freedom' means to them in one word
read -p "  2. In one word, what does 'freedom' mean to you in software? " FREEDOM
echo ""

# Question 3: A project they would build and release
read -p "  3. Name one project you would build and share freely: " BUILD
echo ""

# --- Input validation ---
# -z tests if a variable is empty (zero-length string).
# The || operator chains conditions: if ANY of the three inputs is empty, abort.
if [ -z "$TOOL" ] || [ -z "$FREEDOM" ] || [ -z "$BUILD" ]; then
    echo "  ERROR: All three questions must be answered."
    echo "  Please re-run the script and provide all inputs."
    exit 1   # Non-zero exit code signals failure to the calling shell
fi

# --- Dynamic metadata for the manifesto ---
# date '+FORMAT' formats the current date/time using strftime-style codes:
#   %d = day (zero-padded), %B = full month name, %Y = 4-digit year
#   %H = hour (24h), %M = minute
DATE=$(date '+%d %B %Y')
TIME=$(date '+%H:%M')

# whoami returns the username of the currently logged-in user.
# Used to personalise the filename and manifesto signature.
OUTPUT="manifesto_$(whoami).txt"

echo ""
echo "  Generating your manifesto..."
echo ""

# --- Write manifesto to file ---
# '>' creates/overwrites the file with the first line.
# '>>' appends each subsequent line to the same file.
# Variables inside double-quoted strings are expanded (interpolated).

echo "================================================" > "$OUTPUT"
echo "   MY OPEN SOURCE MANIFESTO" >> "$OUTPUT"
echo "   Author  : $(whoami)" >> "$OUTPUT"     # whoami runs at write time
echo "   Date    : $DATE at $TIME" >> "$OUTPUT"
echo "================================================" >> "$OUTPUT"
echo "" >> "$OUTPUT"

# --- Paragraph 1: Gratitude for the daily tool ---
echo "I believe that software is not just code — it is a conversation" >> "$OUTPUT"
echo "between builders across time. Every day, I rely on $TOOL, a tool" >> "$OUTPUT"
echo "that someone chose to share with the world for free. That act of" >> "$OUTPUT"
echo "generosity shapes everything I do." >> "$OUTPUT"
echo "" >> "$OUTPUT"

# --- Paragraph 2: Personal definition of freedom ---
echo "To me, freedom in software means $FREEDOM. Not just the freedom" >> "$OUTPUT"
echo "to use a program, but the freedom to see inside it, to change it," >> "$OUTPUT"
echo "to fix it when it breaks, and to pass it on to someone else. This" >> "$OUTPUT"
echo "is what the GPL, the MIT license, and every open source license" >> "$OUTPUT"
echo "at their best are trying to protect." >> "$OUTPUT"
echo "" >> "$OUTPUT"

# --- Paragraph 3: The project they want to build ---
echo "One day, I want to build $BUILD and release it openly — not" >> "$OUTPUT"
echo "because I expect anything in return, but because the tools I" >> "$OUTPUT"
echo "depend on every day were built by people who felt the same way." >> "$OUTPUT"
echo "Open source is how we pay that debt forward." >> "$OUTPUT"
echo "" >> "$OUTPUT"

# --- Paragraph 4: Git as the case study (fixed OSS context) ---
echo "Git, the software I chose to study for this audit, is a perfect" >> "$OUTPUT"
echo "example of this philosophy in action. Linus Torvalds built it in" >> "$OUTPUT"
echo "2005 out of necessity — proprietary tools had failed the Linux" >> "$OUTPUT"
echo "community — and he gave it away freely under GPL v2. Today, nearly" >> "$OUTPUT"
echo "every developer on earth uses it. That is what open source can do." >> "$OUTPUT"
echo "" >> "$OUTPUT"

# --- Closing signature ---
echo "This is my manifesto. The source is open. The work continues." >> "$OUTPUT"
echo "" >> "$OUTPUT"
echo "                              — $(whoami), $DATE" >> "$OUTPUT"
echo "================================================" >> "$OUTPUT"

# --- Confirm file creation and display the result ---
echo "  Manifesto saved to: $OUTPUT"
echo ""
echo "================================================================"
echo "  YOUR OPEN SOURCE MANIFESTO"
echo "================================================================"
echo ""

# cat reads and prints the saved file to the terminal
cat "$OUTPUT"

echo ""
echo "  Run 'cat $OUTPUT' anytime to re-read your manifesto."
echo "================================================================"
