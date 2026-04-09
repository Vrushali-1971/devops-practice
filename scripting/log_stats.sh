 #!/bin/bash

log_path="$1"

if [ -z "$1" ]; then
	echo "Error: argument is not given"
	exit 1
fi

echo "The current user is: $(whoami)"

echo "The date is: $(date)"

echo "The number of log files are: $(find "$log_path" -name '*.log' | wc -l)"

echo "The number of Error occurrences are: $(grep -c "Error" "$log_path"/error.log)"

echo "Count only users from access.log"
echo "Users are: $(grep -c "User" "$log_path"/access.log)"

echo "Count only errors from error.log"
echo "Errors are: $(grep -c "Error" "$log_path"/error.log)"

echo "Print each log file name"
total_errors=0
for file in "$log_path"/*.log; do
	
        errors="$(grep -c "Error" "$file")"

	if [ "$errors" -ge 1 ]; then
          echo "File: $(basename "$file")"
	  echo "Lines: $(wc -l < "$file")"
	  echo "Errors: $errors"
fi
total_errors=$((total_erros + errors))
done
 echo "Total errors are: $total_errors"



