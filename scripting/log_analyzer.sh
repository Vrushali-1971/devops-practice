#!/bin/bash

#Accept directory as argument, default to "logs"
DIR="${1:-logs}"

# Initialize variables
total=0
max1_errors=0
max2_errors=0
max1_file=""
max2_file=""

# Directory validation
if [ ! -d "$DIR" ]; then
	echo "Directory does not exist"
	exit 1
fi

# Loop through each log file
for file in "$DIR"/*.log; do
        # Skip if no .log files found 
	[ -e "$file" ] || continue
	
        # Count errors in current file
	file_errors=$(grep -ci "error" "$file" 2>/dev/null)
    
	if [ "$file_errors" -gt 0 ]; then
		echo "$(basename "$file") - $file_errors errors"
	fi

	# Add to total
	total=$((total + file_errors))
	
	# Track top 2 files
	if [ "$file_errors"  -gt  "$max1_errors" ]; then
		max2_errors=$max1_errors
                max2_file=$max1_file
		
		max1_errors=$file_errors
		max1_file=$file
	
	elif [ "$file_errors" -gt  "$max2_errors" ]; then
		max2_errors=$file_errors
		max2_file=$file
	fi
done 

# Print total
echo "==== LOG ANALYSIS RESULT ===="
echo "Total errors: $total"

if [ -z "$max1_file" ]; then
	echo "No errors found in any file"
else
	# Print top files
echo "Top 1: $(basename "$max1_file") ($max1_errors errors)"

fi

if [ -z "$max2_file" ]; then 
	echo "Only one file has errors"
else 
	echo "Top 2: $(basename "$max2_file") ($max2_errors errors)"
fi

echo "TOTAL_ERRORS=$total" >> $GITHUB_ENV


# condition

if [ "$total" -eq 0 ]; then
        echo "Status: PASSED (no errors)"
        exit 0
elif [ "$total" -le 5 ]; then
        echo "Status: WARINING (pipeline passed with issues)"
        exit 0
else
        echo "Status: FAILED (too many errors)"
        exit 1
fi

# git practice
