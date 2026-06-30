#!/bin/bash
# install.sh - Install dotfiles using GNU Stow

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

echo "🔗 Installing Dotfiles"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

PACKAGES=(
    "alacritty"
    "bash"
    "distrobox"
    "dolphin"
    "fish"
    "fuzzel"
    "ghostty"
    "helix"
    "kate"
    "konsole"
    "lazygit"
    "lazyvim"
    "noctalia"
    "rofi"
    "starship"
    "vscode"
    "yazi"
    "zed"
)

backup_target() {
    local target=$1
    local backup="${target}.bak.$(date +%Y%m%d%H%M%S)"
    echo "  ! Backing up existing $target to $backup"
    mv "$target" "$backup"
}

get_expected_target() {
    local pkg=$1
    case "$pkg" in
        bash) echo "$HOME/.bashrc" ;;
        lazyvim) echo "$HOME/.config/nvim" ;;
        starship) echo "$HOME/.config/starship.toml" ;;
        *) echo "$HOME/.config/$pkg" ;;
    esac
}

stow_package() {
    local pkg=$1
    local target
    target=$(get_expected_target "$pkg")

    if [ -L "$target" ]; then
        local current
        current=$(readlink -f "$target")
        local expected
        expected=$(readlink -f "$REPO_ROOT/$pkg/.config/$(basename "$target")" 2>/dev/null || echo "")
        if [ "$current" = "$expected" ]; then
            echo "  ✓ $pkg already stowed, skipping..."
            return
        fi
    elif [ -e "$target" ]; then
        backup_target "$target"
    fi

    echo "  → $pkg"
    stow -v "$pkg" 2>&1 | grep -v "BUG in find_stowed_path" || true
}

echo "Stowing configurations..."
for pkg in "${PACKAGES[@]}"; do
    stow_package "$pkg"
done

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Post-install setup..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# LazyVim setup
if command -v nvim &>/dev/null; then
    echo "📦 Setting up LazyVim..."

    if [ -e "$HOME/.config/nvim" ] && [ ! -L "$HOME/.config/nvim" ]; then
        echo "  Backing up existing nvim config..."
        mv "$HOME/.config/nvim" "$HOME/.config/nvim.bak.$(date +%Y%m%d%H%M%S)"
    fi

    if [ -L "$HOME/.config/nvim" ]; then
        nvim_current=$(readlink -f "$HOME/.config/nvim")
        nvim_expected=$(readlink -f "$REPO_ROOT/lazyvim/.config/nvim")
        if [ "$nvim_current" != "$nvim_expected" ]; then
            rm "$HOME/.config/nvim"
        fi
    fi

    if [ ! -e "$HOME/.config/nvim" ]; then
        stow -v lazyvim 2>&1 | grep -v "BUG in find_stowed_path" || true
    fi

    LAZY_PATH="$HOME/.local/share/nvim/lazy/lazy.nvim"
    if [ ! -d "$LAZY_PATH" ]; then
        echo "  Installing lazy.nvim plugin manager..."
        mkdir -p "$HOME/.local/share/nvim/lazy"
        git clone --filter=blob:none --branch=stable https://github.com/folke/lazy.nvim.git "$LAZY_PATH"
    fi

    PLUGIN_COUNT=$(ls -1 "$HOME/.local/share/nvim/lazy/" 2>/dev/null | wc -l)
    if [ "$PLUGIN_COUNT" -lt 5 ]; then
        echo "  Installing LazyVim plugins (this may take a few minutes)..."
        nvim --headless +"Lazy! sync" +q 2>/dev/null || true
    else
        echo "  ✓ LazyVim plugins already installed ($PLUGIN_COUNT plugins), skipping..."
    fi

    echo "✓ LazyVim setup complete"
else
    echo "⚠️  Neovim not found, skipping LazyVim setup"
fi

# Fish plugins
if command -v fish &>/dev/null; then
    echo "📦 Setting up Fish plugins..."

    if fish -c "functions -q fisher" 2>/dev/null; then
        echo "  ✓ Fisher already installed, checking for updates..."
        fish -c "fisher update" 2>/dev/null || true
    else
        echo "  Installing Fisher plugin manager..."
        fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher && fisher update"
    fi
    echo "✓ Fish plugins setup complete"
else
    echo "⚠️  Fish not found, skipping plugin installation"
fi

# VSCodium support
if command -v codium &>/dev/null && ! command -v code &>/dev/null; then
    echo "📦 Detected VSCodium, syncing VS Code settings..."
    mkdir -p "$HOME/.config/VSCodium/User"
    cp -f "$REPO_ROOT/vscode/.config/Code/User/settings.json" "$HOME/.config/VSCodium/User/settings.json" 2>/dev/null || true
    cp -f "$REPO_ROOT/vscode/.config/Code/User/keybindings.json" "$HOME/.config/VSCodium/User/keybindings.json" 2>/dev/null || true
fi

# Distrobox containers
if command -v distrobox &>/dev/null; then
    echo "📦 Setting up Distrobox containers..."
    "$REPO_ROOT/scripts/distrobox-create.sh"
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
