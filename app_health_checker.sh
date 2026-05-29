#!/bin/bash

LOGFILE="app_health.log"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# List of URLs to check
URLS=(
    "https://wisecow.local"
    "http://127.0.0.1:40199"
)

echo "===========================================" | tee -a $LOGFILE
echo "Application Health Report - $TIMESTAMP" | tee -a $LOGFILE
echo "===========================================" | tee -a $LOGFILE

for URL in "${URLS[@]}"; do
    HTTP_STATUS=$(curl -sk -o /dev/null -w "%{http_code}" --max-time 5 "$URL")

    if [ "$HTTP_STATUS" -eq 200 ] 2>/dev/null; then
        echo "✅ UP   - $URL (HTTP $HTTP_STATUS)" | tee -a $LOGFILE
    elif [ "$HTTP_STATUS" -eq 000 ]; then
        echo "❌ DOWN - $URL (No response / Timeout)" | tee -a $LOGFILE
    else
        echo "⚠️  WARN - $URL (HTTP $HTTP_STATUS)" | tee -a $LOGFILE
    fi
done

echo "===========================================" | tee -a $LOGFILE
echo "Report saved to $LOGFILE"
