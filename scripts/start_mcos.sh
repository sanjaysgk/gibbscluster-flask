#!/bin/bash

echo "================================================"
echo "Starting GibbsCluster Web Interface (macOS)"
echo "================================================"
echo ""

# Check if Redis is running
if ! redis-cli ping &> /dev/null; then
    echo "Starting Redis..."
    brew services start redis
    sleep 2
    
    if ! redis-cli ping &> /dev/null; then
        echo "❌ Failed to start Redis"
        echo "Try manually: redis-server"
        exit 1
    fi
fi
echo "✓ Redis is running"

# Kill any existing processes
echo "Stopping old processes..."
pkill -f "celery worker" 2>/dev/null
pkill -f "python run.py" 2>/dev/null
sleep 1

# Start Celery worker in background
echo "Starting Celery worker..."
celery -A celery_worker.celery worker --loglevel=info --logfile=logs/celery.log &
CELERY_PID=$!
sleep 3

# Check if Celery started successfully
if ! ps -p $CELERY_PID > /dev/null; then
    echo "❌ Failed to start Celery worker"
    echo "Check logs/celery.log for details"
    exit 1
fi
echo "✓ Celery worker started (PID: $CELERY_PID)"

# Start Flask application
echo "Starting Flask application..."
python run.py > logs/flask.log 2>&1 &
FLASK_PID=$!
sleep 2

# Check if Flask started successfully
if ! ps -p $FLASK_PID > /dev/null; then
    echo "❌ Failed to start Flask"
    echo "Check logs/flask.log for details"
    kill $CELERY_PID 2>/dev/null
    exit 1
fi
echo "✓ Flask started (PID: $FLASK_PID)"

# Save PIDs
echo $CELERY_PID > logs/celery.pid
echo $FLASK_PID > logs/flask.pid

echo ""
echo "================================================"
echo "✓ All services running!"
echo "================================================"
echo ""
echo "Flask app:  http://localhost:5000"
echo "Celery PID: $CELERY_PID"
echo "Flask PID:  $FLASK_PID"
echo ""
echo "Monitor logs:"
echo "  tail -f logs/celery.log"
echo "  tail -f logs/flask.log"
echo ""
echo "Stop services:"
echo "  ./stop_macos.sh"
echo ""
echo "Optional - Celery monitoring with Flower:"
echo "  celery -A celery_worker.celery flower"
echo "  Then visit: http://localhost:5555"
echo ""