#!/bin/bash

# Check if file path is provided as argument
if [ $# -eq 0 ]; then
    echo "Usage: $0 <conversation_file_path>"
    exit 1
fi

CONV_FILE="$1"

# Check if file exists
if [ ! -f "$CONV_FILE" ]; then
    echo "Error: File '$CONV_FILE' not found"
    exit 1
fi

# Read last 10 lines and find the most recent line with usage information
USAGE_LINE=$(tail -n 10 "$CONV_FILE" | grep -E '"usage"' | tail -n 1)

if [ -z "$USAGE_LINE" ]; then
    echo "No usage information found in the last 10 lines"
    exit 1
fi

# Extract all numeric values from the usage object
TOTAL=$(echo "$USAGE_LINE" | \
    grep -o '"usage":{[^}]*}' | \
    grep -o '[0-9]\+' | \
    awk '{sum += $1} END {print sum}')

echo "Total usage tokens: $TOTAL"