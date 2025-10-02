#!/bin/bash

echo "Starting all services..."

# Start Redis
if ! pgrep redis-server > /dev/null; then
    echo "Starting Redis..."
    redis-server --daemonize yes
    sleep 1
else
    echo "Redis already running"
fi

# Start Celery worker
if ! pgrep -f "celery worker" > /dev/null; then
    echo "Starting Celery worker..."
    celery -A celery_worker.celery worker --loglevel=info --logfile=logs/celery.log --detach
    sleep 2
else
    echo "Celery worker already running"
fi

# Start Flask application
if ! pgrep -f "python run.py" > /dev/null; then
    echo "Starting Flask application..."
    nohup python run.py > logs/flask.log 2>&1 &
    sleep 2
else
    echo "Flask already running"
fi

echo ""
echo "✓ All services started!"
echo "Flask app: http://localhost:5000"
echo "Logs: tail -f logs/flask.log logs/celery.log"
echo ""
echo "Optional - Start Flower for monitoring:"
echo "celery -A celery_worker.celery flower"
