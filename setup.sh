#!/bin/bash

EXAMPLE_FILE="settings.example.json"
SETTINGS_FILE="settings.json" 
TEMP_FILE="settings.tmp.json"

# Check if example file exists
if [ ! -f "$EXAMPLE_FILE" ]; then
    echo "Error: $EXAMPLE_FILE not found"
    exit 1
fi

# Validate example JSON
if ! jq empty "$EXAMPLE_FILE" 2>/dev/null; then
    echo "Error: $EXAMPLE_FILE contains invalid JSON"
    exit 1
fi

# If settings.json doesn't exist, create it from example
if [ ! -f "$SETTINGS_FILE" ]; then
    echo "Creating $SETTINGS_FILE from $EXAMPLE_FILE"
    cp "$EXAMPLE_FILE" "$SETTINGS_FILE"
    echo "Setup complete!"
    exit 0
fi

# Validate existing settings JSON
if ! jq empty "$SETTINGS_FILE" 2>/dev/null; then
    echo "Error: $SETTINGS_FILE contains invalid JSON"
    exit 1
fi

# Merge: example as base, existing settings override conflicts
echo "Merging new properties from $EXAMPLE_FILE into $SETTINGS_FILE"
if ! jq -s '.[0] * .[1]' "$EXAMPLE_FILE" "$SETTINGS_FILE" > "$TEMP_FILE"; then
    echo "Error: Failed to merge JSON files"
    rm -f "$TEMP_FILE"
    exit 1
fi

# Replace original with merged version
mv "$TEMP_FILE" "$SETTINGS_FILE"
echo "Setup complete! Your existing settings have been preserved and new defaults have been added."