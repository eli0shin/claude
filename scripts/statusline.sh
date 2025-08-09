#!/bin/bash

# Read JSON input from stdin
input=$(cat)

# Extract values from JSON
project_dir=$(echo "$input" | jq -r '.workspace.project_dir')
model=$(echo "$input" | jq -r '.model.display_name')
transcript_path=$(echo "$input" | jq -r '.transcript_path')

# Get formatted context info from context_size.sh
context_info=$(~/.claude/scripts/context_size.sh "$transcript_path" 2>/dev/null)

# Build the status line with tokens and model
status_text="$model - $context_info"

# Create the colored status text with color #A3A3A3 (RGB: 163,163,163)
colored_status="\033[38;2;163;163;163m$status_text\033[0m"

printf "%b" "$colored_status"
