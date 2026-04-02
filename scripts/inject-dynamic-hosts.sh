#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/config.sh"

INVENTORY="./ansible/hosts.ini"

echo "--- Generating $INVENTORY ---"

MANAGER_IP=$(multipass info "$MANAGER" | grep IPv4 | awk '{print $2}' | tr -d '\r')

cat > "$INVENTORY" <<EOF
[managers]
$MANAGER ansible_host=$MANAGER_IP ansible_user=ubuntu

[workers]
EOF

for WORKER in "${WORKERS[@]}"; do
    WORKER_IP=$(multipass info "$WORKER" | grep IPv4 | awk '{print $2}' | tr -d '\r')
    echo "$WORKER ansible_host=$WORKER_IP ansible_user=ubuntu" >> "$INVENTORY"
done

cat >> "$INVENTORY" <<EOF

[swarm:children]
managers
workers
EOF

echo "--- Inventory written ---"
cat "$INVENTORY"