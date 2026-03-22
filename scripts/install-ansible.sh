#!/bin/bash
# install-ansible.sh - Install Ansible using system package manager
# Idempotent: skips if ansible is already installed

set -e

echo "📦 Installing Ansible..."
echo ""

# Check if ansible is already installed
if command -v ansible &>/dev/null; then
    echo "✓ Ansible already installed: $(ansible --version | head -1)"
    exit 0
fi

# Check if pkgi alias exists
if ! alias pkgi &>/dev/null; then
    echo "Error: pkgi alias not found. Source your shell config first:"
    echo "  source ~/.bashrc  # for Bash"
    echo "  # or restart Fish shell"
    exit 1
fi

# Detect package manager and install ansible
if command -v dnf &>/dev/null; then
    echo "Detected: Fedora/RHEL (dnf)"
    echo "Installing ansible..."
    sudo dnf install -y ansible ansible-core

elif command -v apt &>/dev/null; then
    echo "Detected: Debian/Ubuntu (apt)"
    echo "Installing ansible..."
    sudo apt update
    sudo apt install -y ansible

elif command -v pacman &>/dev/null; then
    echo "Detected: Arch Linux (pacman)"
    echo "Installing ansible..."
    sudo pacman -S --noconfirm ansible

else
    echo "Error: No supported package manager found"
    exit 1
fi

# Verify installation
if command -v ansible &>/dev/null; then
    echo ""
    echo "✓ Ansible installed successfully: $(ansible --version | head -1)"
else
    echo "Error: Ansible installation failed"
    exit 1
fi
