#!/usr/bin/env bash
set -euo pipefail

echo "Checking if Ansible is installed..."
if ! command -v ansible &> /dev/null; then
    echo "Ansible not found. Installing..."
    
    if ! command -v brew &> /dev/null; then
        echo "Error: Homebrew is required."
        exit 1
    fi

    brew update
    brew install uv
    # Installing ansible via uv tool
    uv tool install ansible-core --with ansible
else
    echo "Ansible is already installed at: $(which ansible)"
fi