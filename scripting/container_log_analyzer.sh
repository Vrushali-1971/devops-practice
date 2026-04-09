#!/bin/bash
CN="$1"
THRESHOLD="$2"
if [ -z "$CN" ]; then 
       echo "Please provide container name"
       exit 1
fi

if [ -z "$THRESHOLD" ]; then
	echo "Please provide threshold"
	exit 1
fi

# Check threshold is number
if ! [[ "$THRESHOLD" =~ ^[0-9]+$ ]]; then
        echo "Threshold must be a number"
	exit 1
fi

# Check if container exists
docker ps -a --format '{{.Names}}' | grep -w "$CN" > /dev/null
if [ $? -ne 0 ]; then
	echo "Container not found"
	exit 1
fi

docker ps --format '{{.Names}}' | grep -w "$CN" > /dev/null
if [ "$?" -eq 0 ]; then
	echo "Container: $CN is running"
else echo "Container: $CN is stopped"
	exit 1
fi

echo "Getting logs...."

issues=$(docker logs "$CN" 2>&1 | grep -Ei -c "error|fail|exception|No such file|warning")

echo "Total issues: $issues"

if [ "$issues" -gt "$THRESHOLD" ]; then
	echo "HIGH ALERT"
else   echo "Normal"
fi

