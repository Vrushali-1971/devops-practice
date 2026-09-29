#!/bin/bash

DIR="$1"

if [ -z "$1" ]; then 
	echo "Usage: $0 <directory path>"
        exit 1
fi

if [ ! -d "$DIR" ]; then 
	echo "Error: Directory "$DIR" does not exist"
	exit 2
else
Total=$(find "$DIR" -maxdepth 1 -type f | wc -l)
Size=$(du -sh "$DIR" | cut -f1)
Name=$(find "$DIR" -maxdepth 1 -type f -exec du -h {} \; | sort -hr | awk 'NR==1 {print $2}')
        echo "Total number of the files inside "$DIR" is: "$Total""
	echo "" 
        echo "Total size of the "$DIR" is: "$Size""
	echo ""
        echo "The name of the largest file inside "$DIR" is: "$Name""
fi





