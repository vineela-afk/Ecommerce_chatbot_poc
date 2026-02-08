#!/bin/bash

# Health check script for Spring Boot backend
# Returns 0 if healthy, 1 if unhealthy

set -e

BACKEND_URL="${BACKEND_URL:-http://localhost:8080}"
TIMEOUT="${TIMEOUT:-30}"
RETRIES="${RETRIES:-5}"
RETRY_COUNT=0

echo "Checking backend health at: $BACKEND_URL"

while [ $RETRY_COUNT -lt $RETRIES ]; do
    if curl -f "$BACKEND_URL/actuator/health" > /dev/null 2>&1; then
        echo "✓ Backend is healthy"
        exit 0
    fi
    
    RETRY_COUNT=$((RETRY_COUNT + 1))
    if [ $RETRY_COUNT -lt $RETRIES ]; then
        echo "⏳ Retrying... ($RETRY_COUNT/$RETRIES)"
        sleep 5
    fi
done

echo "✗ Backend health check failed after $RETRIES retries"
exit 1
