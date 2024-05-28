#!/bin/bash

# Directory containing kubeconfig files
CONFIG_DIR="."
# Name of the consolidated kubeconfig file
CONSOLIDATED_CONFIG="../config"

# Build the KUBECONFIG environment variable
KUBECONFIG=$(find "$CONFIG_DIR" -type f -name '*_config' -print0 | xargs -0 | tr '\n' ':')

# Print the KUBECONFIG variable for debugging
echo "KUBECONFIG=$KUBECONFIG"

# Check if the KUBECONFIG variable is not empty
if [ -z "$KUBECONFIG" ]; then
  echo "No kubeconfig files found in $CONFIG_DIR"
  exit 1
fi

# Merge and flatten the configs
KUBECONFIG=$KUBECONFIG kubectl config view --merge --flatten >"$CONSOLIDATED_CONFIG"

# Check if the consolidated config file is created and not empty
if [ ! -s "$CONSOLIDATED_CONFIG" ]; then
  echo "Failed to create consolidated kubeconfig"
  exit 1
else
  echo "Consolidated kubeconfig created at $CONSOLIDATED_CONFIG"
fi
