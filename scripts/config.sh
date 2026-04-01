#!/usr/bin/env bash
# Shared configuration for all scripts.
# source "$(dirname "$0")/../config.sh" (or adjust path as needed)

MANAGER="swarm-manager"
WORKERS=("swarm-worker-1" "swarm-worker-2" "swarm-worker-3")
ALL_VMS=("$MANAGER" "${WORKERS[@]}")

CLOUD_INIT="./cloud-init.yml"

VM_CPUS=1
VM_MEM="1G"
VM_DISK="2G"
