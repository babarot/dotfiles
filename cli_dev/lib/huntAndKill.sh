#!/bin/bash

# Function to display process details with bat
preview_process() {
  local pid=$1
  if [[ -n "$pid" ]]; then
    lsof -nP -p $pid | bat -l log --color always --theme TwoDark
  fi
}

# Get a pattern from the user
read -rp "Enter port number or process keyword to search: " pattern

# Use ripgrep to filter lsof output, then pass to fzf
selected_process=$(lsof -nP | rg "$pattern" | fzf --ansi --preview 'preview_process {1}' --preview-window=down:15:wrap)

# Extract the PID from the selected process
pid_to_kill=$(echo $selected_process | awk '{print $2}')

# Kill the selected process
if [[ -n "$pid_to_kill" ]]; then
  echo "Killing PID: $pid_to_kill"
  kill $pid_to_kill
else
  echo "No process selected or invalid PID."
fi
