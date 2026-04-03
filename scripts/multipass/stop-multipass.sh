#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../config.sh"

echo "--- Stopping swarm VMs ---"
for VM in "${ALL_VMS[@]}"; do
    if multipass list | grep -q "$VM.*Running"; then
        echo "  Stopping $VM..."
        multipass stop "$VM"
    else
        echo "  $VM is not running, skipping..."
    fi
done

echo "Done."
