#!/bin/bash

# Check if python is installed
if ! command -v python3 &> /dev/null
then
    echo "Python3 could not be found. Please install Python."
    exit
fi

# Create virtual environment if it doesn't exist
if [ ! -d "venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv venv
fi

# Activate virtual environment
source venv/bin/activate

# Install dependencies
echo "Installing dependencies..."
pip install -r requirements.txt

# Run the app
echo "Starting the application..."
python app.py
