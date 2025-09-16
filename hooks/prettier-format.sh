#!/bin/bash

# Prettier hook for Claude Code
# Formats files with prettier after edits

# Source utilities
source "$(dirname "$0")/utils.sh"

# Read input from stdin
INPUT=$(cat)

# Parse input and extract fields
if ! parse_hook_input "$INPUT"; then
    exit 0
fi

# Check if project has local prettier hook override
if has_project_hook_override "$PROJECT_DIR" "prettier"; then
    exit 0
fi

# Check if project has prettier configured
if ! has_prettier_config "$PROJECT_DIR"; then
    exit 0
fi

# Run prettier on the file
PRETTIER_OUTPUT=$(cd "$PROJECT_DIR" && bunx prettier --write "$FILE_PATH" 2>&1)
PRETTIER_EXIT_CODE=$?

# Always exit 0 - prettier should never block operations
# Syntax errors will be caught by eslint/LSP
# Technical issues (missing deps, config problems) should fail silently
if [[ $PRETTIER_EXIT_CODE -ne 0 ]]; then
    # Log the error for debugging but don't block
    echo "Prettier encountered an issue with $FILE_PATH (exit code: $PRETTIER_EXIT_CODE): $PRETTIER_OUTPUT" >&2
fi

exit 0
