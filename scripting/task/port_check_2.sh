#!/bin/bash

PORT="$1"

if [ -z "$PORT" ]; then
    echo "Usage: $0 <port>"
    exit 1
fi

RESULT=$(sudo ss -tulpn "sport = :$PORT")

if [ -z "$RESULT" ]; then
    echo "Nothing is listening on port $PORT"
else
    echo "Port $PORT is currently listening"
    echo "$RESULT"
fi
