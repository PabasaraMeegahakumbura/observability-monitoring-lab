#!/bin/bash

# Custom Nagios/NRPE Docker service health check.
# Exit codes: 0 OK, 2 CRITICAL.

if systemctl is-active --quiet docker; then
    echo "DOCKER OK - Docker service is running"
    exit 0
else
    echo "DOCKER CRITICAL - Docker service is not running"
    exit 2
fi
