#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../config.sh"

SSH_KEY=""
for key_file in "$HOME/.ssh/id_ed25519.pub" "$HOME/.ssh/id_rsa.pub"; do
    if [[ -f "$key_file" ]]; then
        SSH_KEY=$(cat "$key_file")
        echo "Using SSH key: $key_file"
        break
    fi
done

if [[ -z "$SSH_KEY" ]]; then
    echo "Warning: No SSH public key found in ~/.ssh/"
    echo "Ansible will not be able to connect via SSH."
    echo "Generate one with: ssh-keygen -t ed25519"
fi

echo "--- Creating VMs ---"
for VM in "${ALL_VMS[@]}"; do
    if multipass list | grep -q "$VM"; then
        echo "VM '$VM' already exists, skipping..."
    else
        echo "Creating VM: $VM..."
        multipass launch --name "$VM" \
            --cpus "$VM_CPUS" \
            --memory "$VM_MEM" \
            --disk "$VM_DISK" \
            --cloud-init "$CLOUD_INIT"
    fi
done

if [[ -n "$SSH_KEY" ]]; then
    echo "--- Injecting SSH public key into VMs ---"
    for VM in "${ALL_VMS[@]}"; do
        multipass exec "$VM" -- bash -c "
            mkdir -p /home/ubuntu/.ssh
            grep -qF '$SSH_KEY' /home/ubuntu/.ssh/authorized_keys 2>/dev/null || \
                echo '$SSH_KEY' >> /home/ubuntu/.ssh/authorized_keys
        "
        echo "  Key injected into $VM"
    done
fi

echo "--- All VMs ready ---"
multipass list
