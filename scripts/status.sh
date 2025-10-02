#!/bin/bash

echo "Service Status:"
echo "==============="

# Check Redis
if pgrep redis-server > /dev/null; then
    echo "✓ Redis: Running"
else
    echo "✗ Redis: Not running"
fi

# Check Celery
if pgrep -f "celery worker" > /dev/null; then
    echo "✓ Celery: Running"
else
    echo "✗ Celery: Not running"
fi

# Check Flask
if pgrep -f "python run.py" > /dev/null; then
    echo "✓ Flask: Running"
else
    echo "✗ Flask: Not running"
fi

echo ""
echo "Celery Queue Status:"
redis-cli -n 0 LLEN celery 2>/dev/null | xargs echo "Jobs in queue:"
