#!/bin/bash
# bootstrap.sh - Initial system setup and dependency installation
# This script detects your Linux distribution and installs required tools

set -e

echo "🚀 Dotfiles Bootstrap Script"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Detect package manager
if command -v dnf &>/dev/null; then
    PKG_MGR="dnf"
    PKG_INSTALL="sudo dnf install -y"
    DISTRO="Fedora/RHEL"
elif command -v apt &>/dev/null; then
    PKG_MGR="apt"
    PKG_INSTALL="sudo apt install -y"
    DISTRO="Debian/Ubuntu"
elif command -v pacman &>/dev/null; then
    PKG_MGR="pacman"
    PKG_INSTALL="sudo pacman -S --noconfirm"
    DISTRO="Arch Linux"
else
    echo "❌ Error: No supported package manager found (dnf, apt, or pacman)"
    exit 1
fi

echo "📦 Detected distribution: $DISTRO ($PKG_MGR)"
echo ""

# Core dependencies
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "1️⃣  Installing core dependencies..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

CORE_DEPS="git stow curl wget"
$PKG_INSTALL $CORE_DEPS

# Modern CLI tools
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "2️⃣  Installing modern CLI tools..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Package names may vary by distro
if [ "$PKG_MGR" = "dnf" ]; then
    CLI_TOOLS="fish eza bat fd-find ripgrep fzf zoxide starship direnv atuin \
               git-delta sd dust duf btop procs hyperfine tealdeer jq yq xh \
               glow lazygit tokei hexyl gh"
elif [ "$PKG_MGR" = "apt" ]; then
    CLI_TOOLS="fish exa bat fd-find ripgrep fzf zoxide starship direnv \
               git-delta sd dust duf btop procs hyperfine tealdeer jq yq xh \
               glow lazygit tokei hexyl gh"
elif [ "$PKG_MGR" = "pacman" ]; then
    CLI_TOOLS="fish eza bat fd ripgrep fzf zoxide starship direnv atuin \
               git-delta sd dust duf btop procs hyperfine tealdeer jq yq xh \
               glow lazygit tokei hexyl github-cli"
fi

$PKG_INSTALL $CLI_TOOLS 2>/dev/null || echo "⚠️  Some packages may not be available, continuing..."

# Fish shell setup
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "3️⃣  Setting up Fish shell..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Add fish to valid shells if not already there
if ! grep -q "$(which fish)" /etc/shells 2>/dev/null; then
    echo "Adding fish to /etc/shells..."
    which fish | sudo tee -a /etc/shells
fi

# Offer to change default shell
echo ""
read -p "Set Fish as your default shell? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    chsh -s "$(which fish)"
    echo "✓ Default shell changed to Fish (restart required)"
else
    echo "⊙ Keeping current default shell"
fi

# Install fonts
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "4️⃣  Installing Nerd Fonts..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

cd "$HOME/.dotfiles/scripts"
./install-fonts.sh

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Bootstrap complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Next steps:"
echo "  1. Run: ./scripts/install.sh"
echo "  2. Restart your terminal"
echo "  3. Enjoy your new dotfiles! 🎉"
echo ""
