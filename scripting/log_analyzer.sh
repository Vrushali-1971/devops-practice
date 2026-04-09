#!/bin/bash
DIR="$1"
total=0
max1_errors=0
max1_file=""
max2_errors=0
max2_file=""

# Argument validation
if [ -z "$DIR" ]; then
	echo "Please provide directory path"
	exit 1
fi

if [ -z "$2" ]; then
        echo "please provide second aegument"
	exit 1
fi


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
	file_errors=$(grep -c "ERROR" "$file" 2>/dev/null)
    
	if [ "$file_errors" -gt 0 ]; then
		echo "$(basename "$file") - $file_errors errors"
	fi

	# Add to total
	total=$((total + file_errors))
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
echo "Total errors: $total"

if [ "$total" -ge 5 ]; then
    echo "HIGH ALERT"

elif [ "$total" -ge "$2" ]; then
        echo "Warning"

fi

echo "Top 1: $(basename "$max1_file") ($max1_errors errors)"
echo "Top 2: $(basename "$max2_file") ($max2_errors errors)"


