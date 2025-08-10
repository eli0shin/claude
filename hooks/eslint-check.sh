#!/bin/bash

# ESLint hook for Claude Code
# Checks files with ESLint after edits

# Source utilities
source "$(dirname "$0")/utils.sh"

# Read input from stdin
INPUT=$(cat)

# Parse input and extract fields
if ! parse_hook_input "$INPUT"; then
    exit 0
fi

# Check if project has local eslint hook override
if has_project_hook_override "$CWD" "eslint"; then
    exit 0
fi

# Check if project has eslint configured
if ! has_eslint_config "$CWD"; then
    exit 0
fi

# Check if file matches supported extensions
if ! file_matches_extensions "$FILE_PATH" "js" "jsx" "ts" "tsx"; then
    exit 0
fi

# Run ESLint on the file and capture output
ESLINT_OUTPUT=$(npx eslint "$FILE_PATH" 2>&1)
ESLINT_EXIT_CODE=$?

if [[ $ESLINT_EXIT_CODE -eq 0 ]]; then
    # Silent success
    exit 0
else
    # Show ESLint output and exit with blocking code
    echo "$ESLINT_OUTPUT"
    exit 2
fi