#!/bin/bash

DIR="$!"

# Check if argument is empty
if [ -z "$1" ]; then
	echo "Usage: $0 <path>"
	exit 1
fi

# Check file exists
if [ ! -f "$1" ]; then
	echo "Error: file not found: $1"
	exit 1
fi

lines=$(wc -l < "$1")
error=$(grep -ic "error" "$1")
warning=$(grep -ic "warning" "$1")

echo "----------------------"
echo "Summary"
echo "----------------------"
echo "The number of lines are $lines"
echo ""
echo "The number of errors are $error"
echo ""
echo "The number of warnings are $warning"
echo ""
