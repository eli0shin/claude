#!/bin/bash

# Read JSON input from stdin
input=$(cat)

# Extract values from JSON
project_dir=$(echo "$input" | jq -r '.workspace.project_dir')
model=$(echo "$input" | jq -r '.model.display_name')
transcript_path=$(echo "$input" | jq -r '.transcript_path')

# Calculate context size from transcript if available
context_info=""
if [ "$transcript_path" != "null" ] && [ -f "$transcript_path" ]; then
    # Use the extract_usage.sh script to get total token count
    usage_output=$(~/.claude/extract_usage.sh "$transcript_path" 2>/dev/null)
    
    if [ $? -eq 0 ] && [ -n "$usage_output" ]; then
        # Extract just the number from "Total usage tokens: XXXXX"
        total_tokens=$(echo "$usage_output" | grep -o '[0-9]\+')
        
        if [ -n "$total_tokens" ] && [ "$total_tokens" -gt 0 ]; then
            # Convert to human readable format with percentage of 200k context window
            context_window_size=200000
            usage_percentage=$(((total_tokens * 100) / context_window_size))
            
            if [ "$total_tokens" -gt 1000 ]; then
                token_display=$((total_tokens / 1000))
                context_info="${token_display}k(${usage_percentage}%)"
            else
                context_info="${total_tokens}(${usage_percentage}%)"
            fi
        fi
    fi
fi

# Build the status line with tokens and model
if [ -n "$context_info" ]; then
    status_text="$model - $context_info"
else
    status_text="$model - (0%)"
fi

# Create the colored status text with color #A3A3A3 (RGB: 163,163,163)
colored_status="\033[38;2;163;163;163m$status_text\033[0m"

printf "%b" "$colored_status"
