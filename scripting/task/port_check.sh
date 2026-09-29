#!/bin/bash

PORT="$1"

if [ -z "$PORT" ]; then 
	echo "Error: Usage $0 <Port_No>"
	exit 1
fi

Result="$(sudo ss -tulpn | grep $PORT | awk 'NR==1 {print $2}')"
Process="$(sudo ss -tulpn | grep $PORT | awk 'NR==1 {print $7}')"

if [ "$Result" != LISTEN ]; then 
	echo "Nothing is listening on port $PORT"
	exit 1
else
	echo "Port is currently listening on the system"
	echo ""
	echo "Process/service using $PORT is: $Process"
fi
