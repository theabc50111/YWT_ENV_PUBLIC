#!/bin/bash

SESSION_NAME="aws_q_popup"

# Check if we are currently attached to the popup session
if [[ "$(tmux display-message -p -F "#{session_name}")" = "$SESSION_NAME" ]]; then
    # If we are in the popup, detach from the client
    tmux detach-client
else
    # If the popup session doesn't exist create it and execute the gemini command.
    # Check if the session already exists
    if ! tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
        # Create a new session with the specified name and current path
        tmux new-session -d -s "$SESSION_NAME" -c "#{pane_current_path}"
        # Send the gemini command to the new session
        tmux send-keys -t "$SESSION_NAME" "q" C-m
        # Display the popup with the new session
        tmux display-popup -w 80% -h 80% -x C -y C -E "tmux attach -t $SESSION_NAME"
    else
        # If the session already exists, we will try to attach to it.
        tmux display-popup -w 80% -h 80% -x C -y C -E "tmux attach -t $SESSION_NAME"
    fi
fi
