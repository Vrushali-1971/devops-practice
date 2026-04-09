#!/bin/bash
log_path="$1"
echo "$(date "+%Y-%m-%d %H:%M:%S") - Total lines: $(wc -l "$log_path"/*.log | tail -1 | awk '{print $1}')"
echo "$(date "+%Y-%m-%d %H:%M:%S") - Total errors: $(grep -i "error" "$log_path"/*.log | wc -l)"

