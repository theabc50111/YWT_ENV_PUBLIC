#!/bin/bash

LOG_FILE="$HOME/.py_shell.log"

# create a function to echo log messages with a timestamp
echo_log() {
  local msg="$1"
  echo "=============== $(date '+%y/%m/%d %h:%m:%s') - $msg ==============="
}

# Create the log file if it does not exist
if [ ! -f "$LOG_FILE" ]; then
  touch "$LOG_FILE"
fi

# Run Python script and append output
{ echo_log "$@ START:"; python3 "$@" 2>&1; echo_log "$@ Successfully Executed!!!!!"; cat "$LOG_FILE"; } > "$LOG_FILE.tmp" && mv "$LOG_FILE.tmp" "$LOG_FILE"

tmux display-popup -w 80% -h 60% -x C -y C -E "less $LOG_FILE"
