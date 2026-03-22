#!/bin/bash
# ~/.dotfiles/scripts/install-fonts.sh

set -e

FONT_DIR="$HOME/.local/share/fonts"
NERD_FONTS_VERSION="v3.1.1"
NERD_FONTS_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/${NERD_FONTS_VERSION}"

# Check if fonts are already installed
check_fonts_installed() {
    local font_name=$1
    if fc-list | grep -qi "$font_name"; then
        return 0  # Already installed
    fi
    return 1  # Not installed
}

echo "🔤 Installing Nerd Fonts..."

# Create fonts directory
mkdir -p "$FONT_DIR"
cd "$FONT_DIR"

# Function to download and install a font (only if not already installed)
install_font() {
    local font_name=$1
    local font_variant=$2  # e.g., "JetBrains Mono" for "JetBrainsMonoNerdFont"

    # Check if already installed
    if [ -n "$font_variant" ] && check_fonts_installed "$font_variant"; then
        echo "  ✓ ${font_name} already installed, skipping..."
        return
    fi

    local zip_file="${font_name}.zip"

    echo "  → Installing ${font_name}..."

    # Download
    wget -q "${NERD_FONTS_URL}/${zip_file}" -O "$zip_file"

    # Extract (exclude Windows-specific files)
    unzip -q -o "$zip_file" -x "*.txt" "*Windows*"

    # Cleanup
    rm "$zip_file"
}

# Best Nerd Fonts for development
# (Choose 3-4 to keep it minimal)
# Check each font before installing

install_font "JetBrainsMono" "JetBrains Mono"
install_font "FiraCode" "FiraCode"
install_font "Hack" "Hack"
install_font "CascadiaCode" "Cascadia Code"
install_font "Symbols"

# Optional: Uncomment if you want more variety
# install_font "Meslo" "Meslo"
# install_font "RobotoMono" "Roboto Mono"
install_font "UbuntuMono" "Ubuntu Mono"
# install_font "Inconsolata" "Inconsolata"

# Refresh font cache
echo "  → Refreshing font cache..."
fc-cache -fv > /dev/null 2>&1

echo "✅ Fonts installed successfully!"
echo ""
echo "Installed fonts:"
echo "  • JetBrains Mono Nerd Font (Recommended for coding)"
echo "  • Fira Code Nerd Font (Great ligatures)"
echo "  • Hack Nerd Font (Clean & readable)"
echo "  • Cascadia Code Nerd Font (Microsoft)"
echo ""
echo "💡 Set your terminal font to one of these in Alacritty config:"
echo "   ~/.config/alacritty/alacritty.toml"
