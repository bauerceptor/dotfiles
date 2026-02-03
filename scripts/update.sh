#!/bin/bash
# update.sh - Update dotfiles and dependencies

set -e

cd "$HOME/.dotfiles"

echo "🔄 Updating Dotfiles"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Pull latest changes from git
if [ -d ".git" ]; then
    echo "📥 Pulling latest changes..."
    git pull
    echo ""
fi

# Restow configurations
echo "🔗 Restowing configurations..."
./scripts/install.sh

# Update Fish plugins
if command -v fish &>/dev/null; then
    echo ""
    echo "📦 Updating Fish plugins..."
    fish -c "fisher update"
    echo "✓ Fish plugins updated"
fi

# Update fonts
echo ""
read -p "Update fonts? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    ./scripts/install-fonts.sh
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Update complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
