#!/bin/bash

echo "Cleaning up temporary files and data..."

# Clean data directories
rm -rf data/temp/*
rm -rf data/uploads/*
rm -rf data/results/*

# Keep .gitkeep files
touch data/temp/.gitkeep
touch data/uploads/.gitkeep
touch data/results/.gitkeep

# Clean logs
rm -f logs/*.log
touch logs/.gitkeep

echo "✓ Cleanup complete!"
