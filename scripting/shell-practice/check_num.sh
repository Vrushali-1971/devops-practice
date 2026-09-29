#!/bin/bash
Number="$1"

if [ -z "$Number" ]; then
   echo "Provide a number"
   exit 1
fi

if [[ ! "$Number" =~ ^-?[0-9]+$ ]]; then
	echo "Please provide a valid number"
	exit 1
fi

if [ "$Number" -gt 0 ]; then
   echo "The number is positive"
elif [ "$Number" -le 0 ]; then
     echo "The number is negative"
else 
	echo "The number is Zero"
fi

if [ $(( $Number % 2 )) -eq 0 ]; then 
	echo "The number is even"
else 
	echo "The number odd"
fi

if [ "$Number" -gt 100 ]; then 
   echo "Big number!"
fi
