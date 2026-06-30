#!/bin/bash
# update.sh - Update dotfiles and dependencies

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

echo "🔄 Updating dotfiles..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Pull latest changes
if git rev-parse --git-dir >/dev/null 2>&1; then
    echo "⬇️  Pulling latest changes..."
    git pull || echo "⚠️  git pull failed, continuing..."
else
    echo "⚠️  Not a git repository, skipping pull"
fi

# Re-stow configs
echo ""
echo "🔗 Re-stowing configurations..."
"$REPO_ROOT/scripts/install.sh"

# Update Fish plugins
if command -v fish &>/dev/null && fish -c "functions -q fisher" 2>/dev/null; then
    echo ""
    echo "🐟 Updating Fish plugins..."
    fish -c "fisher update" 2>/dev/null || echo "⚠️  Fisher update failed"
fi

# Optionally update fonts
read -rp "Update fonts? (y/N): " font_reply || true
if [[ ${font_reply:-} =~ ^[Yy]$ ]]; then
    "$REPO_ROOT/scripts/install-fonts.sh"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Update complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
