#!/bin/bash

cd "$(dirname "$0")"

if [ ! -f "config/config.env" ]; then
    echo "Error: config.env not found"
    exit 1
fi

if [ ! -f "assets/submissions.txt" ]; then
    echo "Error: submissions.txt not found"
    exit 1
fi

echo "Starting Submission Reminder Application"
echo "========================================"

./app/reminder.sh
