#!/bin/bash

usage=$(df -h / | awk 'NR==2 {print $5}')
mem_used=$(free -h | awk 'NR==2 {print $3}')
mem_total=$(free -h | awk 'NR==2 {print $2}')
lavg=$(uptime | awk '{print $8, $9, $10}')
proc=$(ps aux --sort=-%cpu | awk 'NR>1 && NR<=4 {printf "  %d. %-20s (%s%%)\n", NR-1, $11, $3}')

echo "========== System Health =========="
echo ""
echo "Disk Usage (/): $usage"
echo ""
echo "Memory: $mem_used used / $mem_total total"
echo ""
echo "Load Average: $lavg"
echo ""
echo "Top 3 CPU Processes:"
echo "$proc"
