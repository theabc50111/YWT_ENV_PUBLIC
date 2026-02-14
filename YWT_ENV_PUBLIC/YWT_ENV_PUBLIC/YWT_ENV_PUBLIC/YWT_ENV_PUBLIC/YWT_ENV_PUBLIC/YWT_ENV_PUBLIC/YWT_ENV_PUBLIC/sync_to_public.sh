#!/bin/bash

# Create a temporary directory for modifications
TEMP_DIR=$(mktemp -d)
echo "Created temporary directory: $TEMP_DIR"

# Copy YWT_ENV to the temporary directory
echo "Copying YWT_ENV to temporary directory..."
cp -r ./* "$TEMP_DIR"
find "$TEMP_DIR" -name ".git" -type d -exec rm -rf {} +
find "$TEMP_DIR" -name "*.md" -type f -delete

# Category 1: File Deletions
echo "Removing files that are not in YWT_ENV_PUBLIC..."
rm -f "$TEMP_DIR/DockerSettings_YWT/jupyterlab/jupyter_lab_config.py"
rm -f "$TEMP_DIR/DockerSettings_YWT/pytorch:latest-gpu-jupyterlab/jupyter_lab_config.py"
rm -f "$TEMP_DIR/DockerSettings_YWT/tensorflow:latest-gpu-jupyterlab3.6.3/jupyter_lab_config.py"
rm -f "$TEMP_DIR/DockerSettings_YWT/tensorflow:latest-gpu-jupyterlab4/jupyter_lab_config.py"
rm -f "$TEMP_DIR/SystemSettings_YWT/hosts"

# Sync to YWT_ENV_PUBLIC, excluding .git and *.md files
echo "Syncing modified files to YWT_ENV_PUBLIC..."
cp -rT "$TEMP_DIR/" YWT_ENV_PUBLIC/

# Clean up the temporary directory
echo "Cleaning up temporary directory..."
rm -rf "$TEMP_DIR"

echo "Synchronization complete!"
