#!/bin/bash

LOGFILE="health_report.log"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

CPU_THRESHOLD=80
MEMORY_THRESHOLD=80
DISK_THRESHOLD=80

echo "===========================================" | tee -a $LOGFILE
echo "System Health Report - $TIMESTAMP" | tee -a $LOGFILE
echo "===========================================" | tee -a $LOGFILE

# CPU Usage
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'.' -f1)
echo "CPU Usage: ${CPU_USAGE}%" | tee -a $LOGFILE
if [ "$CPU_USAGE" -gt "$CPU_THRESHOLD" ]; then
    echo "⚠️  ALERT: CPU usage is above ${CPU_THRESHOLD}%!" | tee -a $LOGFILE
fi

# Memory Usage
MEMORY_USAGE=$(free | awk '/Mem:/ {printf "%.0f", $3/$2 * 100}')
echo "Memory Usage: ${MEMORY_USAGE}%" | tee -a $LOGFILE
if [ "$MEMORY_USAGE" -gt "$MEMORY_THRESHOLD" ]; then
    echo "⚠️  ALERT: Memory usage is above ${MEMORY_THRESHOLD}%!" | tee -a $LOGFILE
fi

# Disk Usage
DISK_USAGE=$(df / | awk 'NR==2 {print $5}' | tr -d '%')
echo "Disk Usage: ${DISK_USAGE}%" | tee -a $LOGFILE
if [ "$DISK_USAGE" -gt "$DISK_THRESHOLD" ]; then
    echo "⚠️  ALERT: Disk usage is above ${DISK_THRESHOLD}%!" | tee -a $LOGFILE
fi

# Running Processes
PROCESS_COUNT=$(ps aux --no-headers | wc -l)
echo "Running Processes: $PROCESS_COUNT" | tee -a $LOGFILE

echo "===========================================" | tee -a $LOGFILE
echo "Report saved to $LOGFILE"
