 #!/bin/bash

log_path="$1"

if [ -z "$1" ]; then
	echo "Error: argument is not given"
	exit 1
fi

echo "The current user is: $(whoami)"

echo "The date is: $(date)"

echo "The number of log files are: $(find "$log_path" -name '*.log' | wc -l)"

echo "The number of Error occurrences are: $(grep -o "Error" "$log_path"/*.log | wc -l)" 
