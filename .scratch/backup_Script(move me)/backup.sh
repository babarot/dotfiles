#!/bin/bash

# Set the backup directory to a folder named "backups" inside the Dropbox directory
backup_dir="$HOME/Dropbox/backup/$(date +%Y-%m-%d)"

# Array of source directories to backup
src_dirs=(
  "$HOME/Code"
  "$HOME/Downloads"
  "$HOME/Documents"
)

backup_directory() {
  local src_dir="$1"
  local backup_prefix="$(basename "$src_dir").backup.tar.gz"
  local backup_file="$backup_dir/$backup_prefix"
  local checksum_file="$backup_dir/$(basename "$src_dir").checksum"

  mkdir -p "$backup_dir"

  local total_size=$(du -sk "$src_dir" | awk '{print $1}')

  echo "Creating: $backup_file"
  tar czf - "$src_dir" | pv -s "${total_size}k" > "$backup_file"
  echo

  # Create checksum file for individual files
  find "$src_dir" -type f -exec md5sum {} \; > "$checksum_file"
  echo "Checksum file created: $checksum_file"
  echo "Backup completed. Archive file: $backup_file"
}

extract_and_verify() {
  local backup_prefix="$1"
  local backup_file="$backup_dir/$backup_prefix.backup.tar.gz"
  local checksum_file="$backup_dir/$(basename "$backup_prefix").checksum"

  if [ -f "$backup_file" ] && [ -f "$checksum_file" ]; then
    echo "Extracting: $backup_file"
    pv "$backup_file" | tar -xzf - -C "$backup_dir"
    echo

    echo "Verifying checksums..."
    cd "$backup_dir/$(basename "$backup_prefix")"
    md5sum -c "$checksum_file"
    cd - > /dev/null
    echo "Extraction and verification completed."
  else
    echo "Backup archive or checksum file not found."
  fi
}

# Function to backup all specified directories
backup_all() {
  for src_dir in "${src_dirs[@]}"; do
    backup_directory "$src_dir"
  done
}

# Check if an action is provided as an argument
if [ $# -eq 0 ]; then
  # If no action is provided, default to backup_all
  action="backup_all"
else
  action="$1"
fi

# Perform backup or extraction based on the action argument
case "$action" in
  backup_all)
    backup_all
    ;;
  extract)
    if [ $# -lt 2 ]; then
      echo "Usage: $0 extract <backup_prefix>"
      exit 1
    fi
    extract_and_verify "$2"
    ;;
  *)
    echo "Invalid action. Use 'backup_all' or 'extract'."
    exit 1
    ;;
esac