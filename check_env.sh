#!/bin/bash
set -euo pipefail

echo "NOTE: Validating required commands in PATH."

for cmd in az terraform jq; do
  if ! command -v "$cmd" &>/dev/null; then
    echo "ERROR: Required command not found: $cmd"
    exit 1
  fi
  echo "NOTE: Found required command: $cmd"
done

echo "NOTE: Checking Azure CLI authentication..."
if ! az account show &>/dev/null; then
  echo "ERROR: Not logged in to Azure. Run: az login"
  exit 1
fi

echo "NOTE: Azure CLI authentication successful."
