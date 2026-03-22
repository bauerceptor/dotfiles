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
    "niri"
    "noctalia"
    "starship"
    "vscode"
    "yazi"
    "zed"
)

# Stow each package (skip if already properly linked)
echo "Stowing configurations..."
for pkg in "${PACKAGES[@]}"; do
    # Check if already stowed correctly
    case "$pkg" in
        fish)
            TARGET_DIR="$HOME/.config/fish"
            ;;
        bash)
            TARGET_DIR="$HOME/.bashrc"
            ;;
        lazyvim)
            TARGET_DIR="$HOME/.config/nvim"
            ;;
        starship)
            TARGET_DIR="$HOME/.config/starship.toml"
            ;;
        *)
            TARGET_DIR="$HOME/.config/$pkg"
            ;;
    esac

    # Check if already linked to our dotfiles
    if [ -L "$TARGET_DIR" ]; then
        CURRENT_TARGET="$(readlink -f "$TARGET_DIR")"
        EXPECTED_TARGET="$(readlink -f "$HOME/.dotfiles/$pkg/.config/$pkg" 2>/dev/null || echo "$CURRENT_TARGET")"
        if [ "$CURRENT_TARGET" = "$EXPECTED_TARGET" ]; then
            echo "  ✓ $pkg already stowed, skipping..."
            continue
        fi
    elif [ -e "$TARGET_DIR" ]; then
        echo "  ! $pkg has existing config, backing up..."
        mv "$TARGET_DIR" "$TARGET_DIR.bak"
    fi

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

# Setup LazyVim
if command -v nvim &>/dev/null; then
    echo "📦 Setting up LazyVim..."

    # Backup existing nvim config if it exists and is not a symlink
    if [ -e "$HOME/.config/nvim" ] && [ ! -L "$HOME/.config/nvim" ]; then
        echo "  Backing up existing nvim config..."
        mv "$HOME/.config/nvim" "$HOME/.config/nvim.bak"
    fi

    # Remove existing nvim config if it's a broken symlink or wrong target
    if [ -L "$HOME/.config/nvim" ]; then
        CURRENT_TARGET="$(readlink -f "$HOME/.config/nvim")"
        EXPECTED_TARGET="$(readlink -f "$HOME/.dotfiles/lazyvim/.config/nvim")"
        if [ "$CURRENT_TARGET" != "$EXPECTED_TARGET" ]; then
            rm "$HOME/.config/nvim"
        fi
    fi

    # Stow lazyvim if not already linked
    if [ ! -e "$HOME/.config/nvim" ]; then
        stow -v lazyvim 2>&1 | grep -v "BUG in find_stowed_path" || true
    fi

    # Install lazy.nvim if not present
    LAZY_PATH="$HOME/.local/share/nvim/lazy/lazy.nvim"
    if [ ! -d "$LAZY_PATH" ]; then
        echo "  Installing lazy.nvim plugin manager..."
        mkdir -p "$HOME/.local/share/nvim/lazy"
        git clone --filter=blob:none --branch=stable https://github.com/folke/lazy.nvim.git "$LAZY_PATH"
    fi

    # Check if plugins are already installed (lazy-lock.json exists and has content)
    LAZY_LOCK="$HOME/.dotfiles/lazyvim/.config/nvim/lazy-lock.json"
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

# Setup Fish plugins via Fisher (skip if already installed)
if command -v fish &>/dev/null; then
    echo "📦 Setting up Fish plugins..."

    # Check if fisher is already installed
    if fish -c "functions -q fisher" 2>/dev/null; then
        echo "  ✓ Fisher already installed, checking for updates..."

        # Check if plugins file exists and needs update
        PLUGINS_FILE="$HOME/.config/fish/fish_plugins"
        if [ -f "$PLUGINS_FILE" ]; then
            fish -c "fisher update" 2>/dev/null || true
        fi
    else
        echo "  Installing Fisher plugin manager..."
        fish -c "
            curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source
            fisher install jorgebucaran/fisher
            fisher update
        "
    fi
    echo "✓ Fish plugins setup complete"
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
