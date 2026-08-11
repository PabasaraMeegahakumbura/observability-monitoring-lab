#!/bin/bash

# Custom Nagios/NRPE memory usage check.
# Exit codes: 0 OK, 1 WARNING, 2 CRITICAL.

WARN=80
CRIT=90

MEM_USED=$(free | awk '/Mem:/ {printf("%.0f"), $3/$2 * 100}')

if [ "$MEM_USED" -ge "$CRIT" ]; then
    echo "MEMORY CRITICAL - ${MEM_USED}% used"
    exit 2
elif [ "$MEM_USED" -ge "$WARN" ]; then
    echo "MEMORY WARNING - ${MEM_USED}% used"
    exit 1
else
    echo "MEMORY OK - ${MEM_USED}% used"
    exit 0
fi
