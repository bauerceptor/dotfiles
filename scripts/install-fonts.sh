#!/bin/bash
# ~/.dotfiles/scripts/install-fonts.sh

set -e

FONT_DIR="$HOME/.local/share/fonts"
NERD_FONTS_VERSION="v3.1.1"
NERD_FONTS_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/${NERD_FONTS_VERSION}"

echo "🔤 Installing Nerd Fonts..."

# Create fonts directory
mkdir -p "$FONT_DIR"
cd "$FONT_DIR"

# Function to download and install a font
install_font() {
    local font_name=$1
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

install_font "JetBrainsMono"      # Best for coding (ligatures, clear)
install_font "FiraCode"           # Popular, great ligatures
install_font "Hack"               # Clean, readable
install_font "CascadiaCode"       # Microsoft's coding font (Cascadia Code)
install_font "Symbols"

# Optional: Uncomment if you want more variety
# install_font "Meslo"            # Good for terminals
# install_font "RobotoMono"       # Clean, modern
install_font "UbuntuMono"       # If you like Ubuntu's style
# install_font "Inconsolata"      # Classic monospace

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