#!/bin/bash
# install.sh - Install dotfiles using GNU Stow

set -e

cd "$HOME/.dotfiles"

echo "🔗 Installing Dotfiles"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# List of packages to stow
PACKAGES=(
    "alacritty"
    "bash"
    "fish"
    "ghostty"
    "helix"
    "lazygit"
    "lazyvim"
    "starship"
    "vscode"
    "yazi"
    "zed"
)

# Stow each package
echo "Stowing configurations..."
for pkg in "${PACKAGES[@]}"; do
    echo "  → $pkg"
    stow -v "$pkg" 2>&1 | grep -v "BUG in find_stowed_path" || true
done

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Dotfiles installed!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Post-install tasks
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Post-install setup..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Setup Fish plugins via Fisher
if command -v fish &>/dev/null; then
    echo "📦 Installing Fish plugins..."
    fish -c "
        if not functions -q fisher
            echo 'Installing Fisher plugin manager...'
            curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source
            fisher install jorgebucaran/fisher
        end

        echo 'Installing plugins from fish_plugins...'
        fisher update
    "
    echo "✓ Fish plugins installed"
else
    echo "⚠️  Fish not found, skipping plugin installation"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✨ Installation complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Next steps:"
echo "  1. Restart your terminal"
echo "  2. Run: source ~/.bashrc (for Bash)"
echo "  3. Or start a new Fish shell"
echo "  4. Check available themes: ./scripts/switch-theme.sh"
echo ""
