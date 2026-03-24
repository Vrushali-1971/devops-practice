#!/bin/bash

if [ -z "$1" ]; then 
	echo "Usage: ./user_check.sh <username>"
	exit 1
fi
if grep -q "^$1:" /etc/passwd; then 
	echo "User exists and home directory is:"
        grep "$1" /etc/passwd | cut -d: -f6 
else
	echo "User not found"
fi
