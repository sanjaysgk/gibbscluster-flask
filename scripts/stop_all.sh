#!/bin/bash

echo "Stopping all services..."

# Stop Flask
echo "Stopping Flask..."
pkill -f "python run.py"

# Stop Celery worker
echo "Stopping Celery worker..."
pkill -f "celery worker"

# Stop Redis
echo "Stopping Redis..."
redis-cli shutdown 2>/dev/null

echo "✓ All services stopped!"
