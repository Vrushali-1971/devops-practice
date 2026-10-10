#!/bin/bash

sourc="$1"
dest="$2"

if [ -z "$sourc" ] || [ -z "$dest" ]; then
	echo "Usage: $0 <source-folder> <destination-folder>"
	exit 1
fi

if [ ! -d "$sourc" ]; then 
	echo "Error: Source "$sourc" does not exist or is not a directory"
	exit 1
fi

mkdir -p "$dest"

src_name=$(basename "$sourc")
file="$dest/${src_name}-$(date +%Y%m%d).tar.gz"

tar -czf "$file" "$sourc"

if [ $? -eq 0 ]; then
	echo "Backup complete: $file"
else
	echo "Backup failed"
	exit 1
fi
