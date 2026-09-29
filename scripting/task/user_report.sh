#!/bin/bash

printf "%-20s %-30s %-15s\n" "USERNAME" "HOME DIRECTORY" "STATUS"

awk -F: '{print $1,$6}' /etc/passwd |
while read -r user home
do 
	if [ -d "$home" ]; then
		if who | awk '{print $1}' | grep -q "^$user$"; then
			printf "%-20s %-30s %-15s\n" "$user" "$home" "Logged in"
		else 
			printf "%-20s %-30s %-15s\n" "$user" "$home" "Not Logged in"
		fi
	fi
done
