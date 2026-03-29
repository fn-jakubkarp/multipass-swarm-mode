#!/usr/bin/env bash

TARGET_VM=(
    "web-01"
    "web-02"
    "db-01"
)

for VM in "${TARGET_VM[@]}"; do
    if multipass list | grep -q "$VM"; then
        echo "VM: $VM already exists, skipping..."
    else
        echo "Creating VM: $VM..."
        multipass launch --name "$VM" --cpus 1 --mem 1G --disk 2G --cloud-init ./cloud-init.yml
    fi
done