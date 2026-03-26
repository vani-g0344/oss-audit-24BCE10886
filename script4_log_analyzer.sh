LOGFILE=$1
KEYWORD=${2:-"error"}
COUNT=0
MAX_RETRIES=3
RETRY=0

echo "           LOG FILE ANALYZER — OSS AUDIT TOOL                  "
echo ""


if [ -z "$LOGFILE" ]; then
    echo "  Usage: $0 <logfile> [keyword]"
    echo "  Example: $0 /var/log/syslog error"
    echo ""
    echo "  No log file specified. Please provide a path as argument 1."
    exit 1
fi

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


while [ $RETRY -lt $MAX_RETRIES ]; do
    if [ ! -s "$LOGFILE" ]; then
        RETRY=$((RETRY + 1))
        echo "  [Attempt $RETRY/$MAX_RETRIES] File appears empty. Retrying in 1 second..."
        sleep 1
    else
        break
    fi
done

if [ ! -s "$LOGFILE" ]; then
    echo ""
    echo "  WARNING: '$LOGFILE' is empty after $MAX_RETRIES attempts."
    echo "  The file exists but contains no data to analyze."
    exit 0
fi


echo "  SCANNING LOG FILE..."
echo ""


while IFS= read -r LINE; do
    if echo "$LINE" | grep -iq "$KEYWORD"; then
        COUNT=$((COUNT + 1))
    fi
done < "$LOGFILE"

TOTAL_LINES=$(wc -l < "$LOGFILE")

echo "  File           : $LOGFILE"
echo "  Total Lines    : $TOTAL_LINES"
echo "  Keyword        : '$KEYWORD'"
echo "  Occurrences    : $COUNT"
echo ""

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
echo ""

MATCHES=$(grep -i "$KEYWORD" "$LOGFILE" 2>/dev/null)

if [ -n "$MATCHES" ]; then
    echo "$MATCHES" | tail -5 | while IFS= read -r MATCH_LINE; do
        echo "  >> $MATCH_LINE"
    done
else
    echo "  No matching lines to display."
fi

echo ""
echo "  Analysis complete. Always monitor your logs regularly."
