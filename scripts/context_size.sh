#!/bin/bash

# Check if file path is provided as argument
if [ $# -eq 0 ]; then
    echo "Usage: $0 <conversation_file_path>"
    exit 1
fi

CONV_FILE="$1"

# Check if file exists
if [ ! -f "$CONV_FILE" ]; then
    echo "(0%)"
    exit 1
fi

# Read last 10 lines and find the most recent line with usage information
USAGE_LINE=$(tail -n 10 "$CONV_FILE" | grep -E '"usage"' | tail -n 1)

if [ -z "$USAGE_LINE" ]; then
    echo "(0%)"
    exit 1
fi

# Extract all numeric values from the usage object (excluding nested cache_creation) and add them together
TOTAL=$(echo "$USAGE_LINE" | \
    grep -o '"usage":{[^}]*}' | \
    sed 's/"cache_creation":{[^}]*}//g' | \
    grep -o '[0-9]\+' | \
    awk '{sum += $1} END {print sum}')

if [ -n "$TOTAL" ] && [ "$TOTAL" -gt 0 ]; then
    # Convert to human readable format with percentage of 200k context window
    context_window_size=200000
    usage_percentage=$(((TOTAL * 100) / context_window_size))
    
    if [ "$TOTAL" -gt 1000 ]; then
        token_display=$((TOTAL / 1000))
        echo "${token_display}k(${usage_percentage}%)"
    else
        echo "${TOTAL}(${usage_percentage}%)"
    fi
else
    echo "(0%)"
fi
