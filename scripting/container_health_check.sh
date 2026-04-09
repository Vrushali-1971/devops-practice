#!/bin/bash
LOG_DIR="$1"
CN="$2"
THRESHOLD="$3"
if [ -z "$LOG_DIR" ]; then 
	echo "Provide directory path"
	exit 1
fi
if [ -z "$CN" ]; then
	echo "Provide container name"
	exit 1
fi

docker ps --format '{{.Names}}' | grep -w "$CN" > /dev/null
if [ "$?" -eq 0 ]; then 
	echo "Container: $CN is running"
else echo "Container: $CN is stopped"
	exit 1
fi

echo "Container: $CN"
errors=$(grep -i "error" "$LOG_DIR"/*.log | wc -l)

echo "Errors: $errors"

warnings=$(grep -i "warning" "$LOG_DIR"/*.log | wc -l)
 
echo "warnings: $warnings"

if [ "$errors" -gt "$THRESHOLD" ]; then 
	echo "Status: UNHEALTHY"
else echo "Status: HEALTHY"
fi

