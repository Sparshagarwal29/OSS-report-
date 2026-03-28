#!/bin/bash
# =============================================================
# Script 4: Log File Analyzer
# Author: Sparsh Agarwal | Roll: 24BSA10342
# Course: Open Source Software | VITyarthi
# Description: Reads a log file line by line, counts occurrences
#              of a keyword, shows last 5 matches, and includes
#              retry logic if the file is missing.
# Usage: ./script4_log_analyzer.sh /var/log/syslog error
#        ./script4_log_analyzer.sh /var/log/auth.log warning
# =============================================================

# --- Accept command-line arguments ---
LOGFILE=$1               
KEYWORD=${2:-"error"}   

# --- Counter variable ---
COUNT=0

echo "============================================================"
echo "              LOG FILE ANALYZER — FOSS AUDIT               "
echo "============================================================"

# --- Validate: check if a log file argument was provided ---
if [ -z "$LOGFILE" ]; then
    echo "  [!] No log file specified."
    echo "      Usage: $0 /path/to/logfile [keyword]"
    echo ""
    echo "  Common log files to try:"
    echo "       /var/log/syslog"
    echo "       /var/log/auth.log"
    echo "       /var/log/kern.log"
    exit 1
fi

# --- Validate: check if the file actually exists ---
if [ ! -f "$LOGFILE" ]; then
    echo "  [✘] File '$LOGFILE' not found."
    echo ""
    echo "  Searching for available log files..."

    RETRY=0
    while true; do
        RETRY=$((RETRY + 1))
        for ALT_LOG in /var/log/syslog /var/log/messages /var/log/kern.log /var/log/auth.log; do
            if [ -f "$ALT_LOG" ]; then
                echo "  [✔] Found: $ALT_LOG"
                echo "      Try: $0 $ALT_LOG $KEYWORD"
            fi
        done

        if [ $RETRY -ge 1 ]; then
            break
        fi
    done
    exit 1
fi


if [ ! -s "$LOGFILE" ]; then
    echo "  [!] '$LOGFILE' is empty. Nothing to analyze."
    exit 0
fi

echo "  Log File : $LOGFILE"
echo "  Keyword  : '$KEYWORD' (case-insensitive)"
echo "------------------------------------------------------------"

while IFS= read -r LINE; do

    if echo "$LINE" | grep -iq "$KEYWORD"; then
        COUNT=$((COUNT + 1))   
    fi
done < "$LOGFILE"   

echo ""
echo "  Total matches : $COUNT"
echo "  Keyword '$KEYWORD' found $COUNT time(s) in $LOGFILE"
echo ""

# --- Show the last 5 matching lines ---
if [ $COUNT -gt 0 ]; then
    echo "  --- Last 5 Lines Matching '$KEYWORD' ---"
    grep -i "$KEYWORD" "$LOGFILE" | tail -5 | while IFS= read -r MATCH; do
        echo "  > $MATCH"
    done
else
    echo "  No lines containing '$KEYWORD' were found."
fi

echo ""
echo "============================================================"
