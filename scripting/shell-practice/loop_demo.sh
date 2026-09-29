#!/bin/bash

for i in {1..10}; do
	echo "Number: $i"
done

count=5
while [ $count -gt 0 ]; do 
	echo "Countdown: $count"
	((count--))
done

for file in /etc/*; do
	echo "$file"
done | head -5

for i in 1 2 3 4 5; do
	echo "$i"
done

for i in {1..5}; do
	echo "$i"
done
 
for ((i=1; i<=5; i++)); do
	echo "$i"
done

