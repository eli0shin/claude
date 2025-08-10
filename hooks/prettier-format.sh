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
if has_project_hook_override "$CWD" "prettier"; then
    exit 0
fi

# Check if project has prettier configured
if ! has_prettier_config "$CWD"; then
    exit 0
fi

# Check if file matches supported extensions
if ! file_matches_extensions "$FILE_PATH" "js" "jsx" "ts" "tsx" "mjs" "cjs" "mts" "cts" "json" "css" "scss" "html" "md" "yaml" "yml"; then
    exit 0
fi

# Run prettier on the file
if ! npx prettier --write "$FILE_PATH" 2>/dev/null; then
    echo "Prettier formatting failed for $FILE_PATH"
    exit 2
fi

# Silent success
exit 0