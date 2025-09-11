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
if has_project_hook_override "$PROJECT_DIR" "eslint"; then
    exit 0
fi

# Check if project has eslint configured
if ! has_eslint_config "$PROJECT_DIR"; then
    exit 0
fi

# Check if file matches supported extensions
if ! file_matches_extensions "$FILE_PATH" "js" "jsx" "ts" "tsx" "mjs" "cjs" "mts" "cts"; then
    exit 0
fi

# Run ESLint on the file and capture output
ESLINT_OUTPUT=$(cd "$PROJECT_DIR" && bunx eslint "$FILE_PATH" 2>&1)
ESLINT_EXIT_CODE=$?

if [[ $ESLINT_EXIT_CODE -eq 0 ]]; then
    # Silent success - no errors found
    exit 0
elif [[ $ESLINT_EXIT_CODE -eq 1 ]]; then
    # Rule violations - these should block the agent as they are actionable
    echo "$ESLINT_OUTPUT" >&2
    exit 2
elif [[ $ESLINT_EXIT_CODE -eq 2 ]]; then
    # Technical issues (config errors, missing deps, etc.) - don't block but log for debugging
    echo "ESLint encountered a technical issue with $FILE_PATH (exit code 2): $ESLINT_OUTPUT" >&2
    exit 0
else
    # Unexpected exit code - log and don't block
    echo "ESLint returned unexpected exit code $ESLINT_EXIT_CODE for $FILE_PATH: $ESLINT_OUTPUT" >&2
    exit 0
fi
