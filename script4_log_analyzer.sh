#!/bin/bash
# =============================================================================
# Script 4: Log File Analyzer
# Author  : Vani Gupta | 24BCE10886
# Usage   : ./script4_log_analyzer.sh <logfile> [keyword]
# Example : ./script4_log_analyzer.sh /var/log/syslog error

# =============================================================================

# --- Positional parameters ---
# $1 is the first argument passed to the script (the log file path).
# $2 is the optional keyword; ${2:-"error"} uses "error" as default if $2 is unset.
LOGFILE=$1
KEYWORD=${2:-"error"}

# --- Counters and retry settings ---
COUNT=0        # Will track how many lines match the keyword
MAX_RETRIES=3  # Max attempts to wait for a non-empty file
RETRY=0        # Current retry counter

echo "================================================================"
echo "           LOG FILE ANALYZER — OSS AUDIT TOOL                  "
echo "================================================================"
echo ""

# --- Validate that a log file argument was provided ---
# -z tests if a string is empty (zero length)
if [ -z "$LOGFILE" ]; then
    echo "  Usage: $0 <logfile> [keyword]"
    echo "  Example: $0 /var/log/syslog error"
    echo ""
    echo "  No log file specified. Please provide a path as argument 1."
    exit 1   # Exit with non-zero status to signal an error
fi

# --- Validate that the specified file actually exists ---
# [ ! -f "$LOGFILE" ] is true when the path does NOT exist as a regular file
if [ ! -f "$LOGFILE" ]; then
    echo "  ERROR: File '$LOGFILE' not found on this system."
    echo ""
    echo "  Common log files to try:"
    echo "    /var/log/syslog        (Ubuntu/Debian)"
    echo "    /var/log/messages      (Fedora/RHEL)"
    echo "    /var/log/auth.log      (authentication events)"
    echo "    /var/log/kern.log      (kernel messages)"
    exit 1
fi

echo "  Log File  : $LOGFILE"
echo "  Keyword   : '$KEYWORD' (case-insensitive)"
echo ""

# --- Retry loop: wait for the file to become non-empty ---
# Useful when log files are being actively written to.
# [ ! -s "$LOGFILE" ] is true when the file is empty (size = 0)
while [ $RETRY -lt $MAX_RETRIES ]; do
    if [ ! -s "$LOGFILE" ]; then
        # Arithmetic in bash uses $(( )) for integer operations
        RETRY=$((RETRY + 1))
        echo "  [Attempt $RETRY/$MAX_RETRIES] File appears empty. Retrying in 1 second..."
        sleep 1   # Pause for 1 second before next attempt
    else
        break     # File has content — exit the retry loop
    fi
done

# --- Final check after all retries ---
if [ ! -s "$LOGFILE" ]; then
    echo ""
    echo "  WARNING: '$LOGFILE' is empty after $MAX_RETRIES attempts."
    echo "  The file exists but contains no data to analyze."
    exit 0   # Exit 0 because this is a warning, not a script error
fi

echo "  SCANNING LOG FILE..."
echo "  ----------------------------------------------------------------"
echo ""

# --- Main scan: read every line and count keyword matches ---
# 'while IFS= read -r LINE' reads one line at a time without stripping spaces.
# IFS= prevents leading/trailing whitespace from being trimmed.
# -r prevents backslash sequences from being interpreted.
while IFS= read -r LINE; do
    # grep -iq : -i = case-insensitive, -q = quiet (no output, just exit code)
    # Pipes the current line into grep to check for the keyword
    if echo "$LINE" | grep -iq "$KEYWORD"; then
        COUNT=$((COUNT + 1))   # Increment match counter
    fi
done < "$LOGFILE"   # Redirect file into the while loop as stdin

# --- Count total lines in the file ---
# wc -l counts newlines; '< "$LOGFILE"' feeds it without printing the filename
TOTAL_LINES=$(wc -l < "$LOGFILE")

# --- Display scan summary ---
echo "  File           : $LOGFILE"
echo "  Total Lines    : $TOTAL_LINES"
echo "  Keyword        : '$KEYWORD'"
echo "  Occurrences    : $COUNT"
echo ""

# --- Classify result severity based on match count ---
# Chained if/elif with integer comparison operators: -eq, -lt
if [ $COUNT -eq 0 ]; then
    echo "  Result: No occurrences of '$KEYWORD' found. Log looks clean."
elif [ $COUNT -lt 10 ]; then
    echo "  Result: Low occurrence count. Likely routine activity."
elif [ $COUNT -lt 50 ]; then
    echo "  Result: Moderate occurrences. Worth investigating further."
else
    echo "  Result: HIGH occurrence count! Immediate review recommended."
fi

echo ""
echo "  LAST 5 MATCHING LINES"
echo "  ----------------------------------------------------------------"

# --- Display the last 5 lines that match the keyword ---
# grep -i : case-insensitive search across entire file
# tail -5 : outputs only the last 5 lines of the grep result
MATCHES=$(grep -i "$KEYWORD" "$LOGFILE" 2>/dev/null)

if [ -n "$MATCHES" ]; then
    # -n tests if a string is non-empty (has length > 0)
    # Pipe MATCHES into tail, then loop to add a "  >> " prefix to each line
    echo "$MATCHES" | tail -5 | while IFS= read -r MATCH_LINE; do
        echo "  >> $MATCH_LINE"
    done
else
    echo "  No matching lines to display."
fi

echo ""
echo "  Analysis complete. Always monitor your logs regularly."
echo "================================================================"
