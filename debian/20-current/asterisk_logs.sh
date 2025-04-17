#!/bin/bash

LOGFILE="/var/log/asterisk/messages"
ROTATED_LOGS="/var/log/asterisk/messages.*"
SIZE_LIMIT_MB=200
TOTAL_LIMIT_MB=1024

echo "$(date '+%b %d %H:%M:%S') asterisk_logs[$$]: Check if main log file exceeds 200MB"
if [ -f "$LOGFILE" ]; then
  FILE_SIZE_MB=$(du -m "$LOGFILE" | cut -f1)
  if [ "$FILE_SIZE_MB" -gt "$SIZE_LIMIT_MB" ]; then
    echo "$(date '+%b %d %H:%M:%S') asterisk_logs[$$]: Rotating Asterisk logs (current size: ${FILE_SIZE_MB}MB)..."
    asterisk -rx "logger rotate"
  fi
fi

echo "$(date '+%b %d %H:%M:%S') asterisk_logs[$$]: Calculate total size of rotated logs"
TOTAL_ROTATED_MB=$(du -cm $ROTATED_LOGS 2>/dev/null | grep total | cut -f1)

echo "$(date '+%b %d %H:%M:%S') asterisk_logs[$$]: Remove files until under 1GB"
while [ "$TOTAL_ROTATED_MB" -gt "$TOTAL_LIMIT_MB" ]; do
  # Find file with the highest extension number
  HIGHEST_FILE=$(ls -1 $ROTATED_LOGS 2>/dev/null | \
    grep -E 'messages\.[0-9]+$' | \
    sed 's/.*\.//' | sort -nr | head -n1 | \
    xargs -I{} echo "/var/log/asterisk/messages.{}")

  if [ -f "$HIGHEST_FILE" ]; then
    echo "$(date '+%b %d %H:%M:%S') asterisk_logs[$$]: Removing oldest rotated log: $HIGHEST_FILE"
    rm -f "$HIGHEST_FILE"
  else
    echo "$(date '+%b %d %H:%M:%S') asterisk_logs[$$]: No more rotated log files to remove."
    break
  fi

  # Recalculate size after deletion
  TOTAL_ROTATED_MB=$(du -cm $ROTATED_LOGS 2>/dev/null | grep total | cut -f1)
  echo "$(date '+%b %d %H:%M:%S') asterisk_logs[$$]: Total rotated $TOTAL_ROTATED Mb"
done
