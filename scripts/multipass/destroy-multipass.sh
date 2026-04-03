#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../config.sh"

echo "--- Destroying swarm VMs ---"
for VM in "${ALL_VMS[@]}"; do
    if multipass list | grep -q "$VM"; then
        echo "  Deleting $VM..."
        multipass delete "$VM"
    else
        echo "  $VM not found, skipping..."
    fi
done

echo "Purging deleted instances..."
multipass purge

echo "Done."
