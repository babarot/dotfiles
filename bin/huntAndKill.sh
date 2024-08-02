#!/bin/bash

# Function to display process details with bat
preview_process() {
  local pid=$1
  if [[ -n "$pid" ]]; then
    ps u -p $pid | bat -l log --color always --theme TwoDark
  fi
}

export -f preview_process # Export the function so it's available in the subshell

function interactive_kill_by_name {
  local selected_process=$(ps aux | fzf --header "USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND" --ansi --preview 'bash -c "preview_process {2}"' --preview-window=right:50%:wrap)
  local pid_to_kill=$(echo $selected_process | awk '{print $2}')
  if [[ -n "$pid_to_kill" ]]; then
    echo "Killing PID: $pid_to_kill"
    kill $pid_to_kill
  else
    echo "No process selected or invalid PID."
  fi
}

function interactive_kill_by_port {
  local selected_port=$(lsof -i -nP | awk '{print $9 " " $2}' | sort -u | fzf --header "PORT       PID" --ansi)
  local pid_to_kill=$(echo $selected_port | awk '{print $2}')
  if [[ -n "$pid_to_kill" ]]; then
    echo "Killing process on port with PID: $pid_to_kill"
    kill $pid_to_kill
  else
    echo "No port selected or invalid PID."
  fi
}

# Process command line arguments
case $1 in
processes)
  interactive_kill_by_name
  ;;
ports)
  interactive_kill_by_port
  ;;
*)
  echo "Usage: $0 [processes|ports]"
  echo "  processes: interactively select and kill a process"
  echo "  ports: interactively select and kill a process based on the port it is using"
  ;;
esac
