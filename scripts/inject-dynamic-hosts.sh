#!/usr/bin/env bash
set -euo pipefail


MANAGER="swarm-manager"
WORKERS=("swarm-worker-1" "swarm-worker-2" "swarm-worker-3")

echo "--- Spinning up instances ---"
multipass launch -n "$MANAGER" --cloud-init docker-init.yaml

for WORKER in "${WORKERS[@]}"; do
    multipass launch -n "$WORKER" --cloud-init docker-init.yaml
done

echo "--- Generating hosts.ini ---"

MANAGER_IP=$(multipass info "$MANAGER" | grep IPv4 | awk '{print $2}')
echo "[managers]" > hosts.ini
echo "$MANAGER_IP ansible_user=ubuntu" >> hosts.ini

echo -e "\n[workers]" >> hosts.ini
for WORKER in "${WORKERS[@]}"; do
    W_IP=$(multipass info "$WORKER" | grep IPv4 | awk '{print $2}')
    echo "$W_IP ansible_user=ubuntu" >> hosts.ini
done

echo "--- Running Ansible ---"
ansible-playbook -i hosts.ini configure-swarm.yml