#!/bin/bash

LOG_FILE="/var/log/syslog"

# Check if log file exists and is readable
if [ ! -r "$LOG_FILE" ]; then
    echo "Error: Cannot read $LOG_FILE. Are you running with sufficient permissions?" >&2
    exit 1
fi

# Count ERROR and WARNING lines
ERROR_COUNT=$(grep -ic "ERROR" "$LOG_FILE")
WARNING_COUNT=$(grep -ic "WARNING" "$LOG_FILE")

# Find timestamp of the last ERROR line
LAST_ERROR=$(grep -i "ERROR" "$LOG_FILE" | tail -n 1 | awk '{print $1}')

# Display summary
echo "-------------- Summary Report --------------"
echo
echo "Log file:              $LOG_FILE"
echo "Total ERROR lines:     $ERROR_COUNT"
echo "Total WARNING lines:   $WARNING_COUNT"

if [ -n "$LAST_ERROR" ]; then
    echo "Last ERROR timestamp:  $LAST_ERROR"
else
    echo "Last ERROR timestamp:  No ERROR entries found"
fi

echo "---------------------------------------------"


: << 'COMMENT' # My version 
#!/bin/bash

LOG_FILE="/var/log/syslog"

if [ ! -r "$LOG_FILE" ]; then
    echo "Error: Cannot read $LOG_FILE. Are you running as root/sudo?" >&2
    exit 1
fi

errors="$(grep -i "ERROR" $LOG_FILE | wc -l)"
warnings="$(grep -i "warning" $LOG_FILE | wc -l)"

echo "-------------- Summary Report -------------------"
echo ""
echo "The number of errors in $LOG_FILE are: $errors"
echo ""
echo "The number of warnings in $LOG_FILE are: $warnings"
echo ""
echo "timestamp of the last ERROR line: $(grep -i "ERROR" $LOG_FILE | tail -1 | awk '{print $1}')"
echo ""
COMMENT
