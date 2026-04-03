#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/config.sh"

INVENTORY="./ansible/hosts.ini"

echo "--- Generating $INVENTORY ---"

# 1. Create the file and write the initial manager header
cat > "$INVENTORY" <<EOF
[managers]
EOF

# 2. Run the loop OUTSIDE the cat command
for MANAGER in "${MANAGERS[@]}"; do
    MANAGER_IP=$(multipass info "$MANAGER" | grep IPv4 | awk '{print $2}' | tr -d '\r')
    echo "$MANAGER ansible_host=$MANAGER_IP ansible_user=ubuntu" >> "$INVENTORY"
done

echo -e "\n[workers]" >> "$INVENTORY"

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