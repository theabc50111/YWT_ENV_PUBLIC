#!/bin/bash

# Script to copy customized Gemini CLI slash commands to the project's .gemini/commands directory.

# Source directory where custom command TOML files are located.
SOURCE_DIR="/workspace/codes/YWT_ENV/GeminiCLISettings_YWT"

# Destination directory for project-specific Gemini CLI commands.
DEST_DIR="/workspace/codes/YWT_ENV/.gemini/commands"

echo "Copying Gemini CLI slash commands from '$SOURCE_DIR' to '$DEST_DIR'..."

# Create the destination directory if it doesn't exist.
mkdir -p "$DEST_DIR"
if [ $? -ne 0 ]; then
    echo "Error: Could not create destination directory '$DEST_DIR'."
    exit 1
fi

# Find all .toml files in the source directory and copy them to the destination.
find "$SOURCE_DIR" -type f -name "*.toml" | while read -r cmd_file; do
    echo "Copying: $(basename "$cmd_file")"
    cp "$cmd_file" "$DEST_DIR/"
    if [ $? -eq 0 ]; then
        echo " -> Copied successfully."
    else
        echo " -> Failed to copy."
    fi
done

echo "Command copying process complete."