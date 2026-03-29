#!/usr/bin/env bash
set -euo pipefail

echo "Checking if Ansible is installed..."
if command -v ansible &> /dev/null; then
    echo "Ansible found. Uninstalling..."
    uv tool uninstall ansible-core || true
    brew uninstall ansible || true
    echo "Cleanup complete."
else
    echo "Ansible not found. Nothing to uninstall."
fi