#!/bin/bash
# distrobox-create.sh - Idempotently create Fedora and Ubuntu containers

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DRY_RUN=false

if [ "${1:-}" = "--dry-run" ]; then
    DRY_RUN=true
    echo "🔍 Dry run mode — no containers will be created"
fi

if ! command -v distrobox &>/dev/null; then
    echo "⚠️  distrobox not installed. Skipping container setup."
    exit 0
fi

if ! command -v podman &>/dev/null && ! command -v docker &>/dev/null; then
    echo "⚠️  No container runtime (podman/docker) found. Skipping container setup."
    exit 0
fi

create_container() {
    local name=$1
    local image=$2

    if distrobox list | grep -q "^$name "; then
        echo "✓ Container '$name' already exists, skipping..."
        return
    fi

    if [ "$DRY_RUN" = true ]; then
        echo "Would create container '$name' from $image"
        return
    fi

    echo "→ Creating container '$name' from $image..."
    distrobox create --name "$name" --image "$image" --yes
}

echo "📦 Setting up Distrobox containers..."
create_container "fedora" "registry.fedoraproject.org/fedora-toolbox:latest"
create_container "ubuntu" "quay.io/toolbx/ubuntu-images:latest"

echo ""
echo "✅ Distrobox setup complete!"
echo "Enter a container with: distrobox enter <name>"
