#!/bin/bash
# install-fonts.sh - Install only JetBrainsMono and Lilex Nerd Fonts

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FONT_DIR="$HOME/.local/share/fonts"
NERD_FONTS_VERSION="3.1.1"

mkdir -p "$FONT_DIR"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔤 Installing Nerd Fonts"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

font_exists() {
    local pattern=$1
    fc-list | grep -i "$pattern" >/dev/null 2>&1
}

install_font_from_zip() {
    local name=$1
    local zip_file=$2

    echo "→ Installing $name from local zip..."
    unzip -q -o "$zip_file" -d "$FONT_DIR"
}

install_font_from_github() {
    local name=$1
    local url="https://github.com/ryanoasis/nerd-fonts/releases/download/v${NERD_FONTS_VERSION}/${name}.zip"

    echo "→ Downloading $name..."
    wget -q "$url" -O "/tmp/${name}.zip"
    unzip -q -o "/tmp/${name}.zip" -d "$FONT_DIR"
    rm -f "/tmp/${name}.zip"
}

install_font() {
    local display_name=$1
    local nerd_name=$2
    local local_zip
    local_zip=$(find "$REPO_ROOT" -maxdepth 1 -iname "${nerd_name}*.zip" | head -n1)

    if font_exists "$display_name"; then
        echo "✓ $display_name already installed, skipping..."
        return
    fi

    if [ -n "$local_zip" ] && [ -f "$local_zip" ]; then
        install_font_from_zip "$display_name" "$local_zip"
    else
        install_font_from_github "$nerd_name"
    fi

    echo "✓ $display_name installed"
}

# Only install the two fonts we care about
install_font "JetBrainsMono Nerd Font" "JetBrainsMono"
install_font "Lilex Nerd Font" "Lilex"

echo ""
echo "→ Rebuilding font cache..."
fc-cache -fv "$FONT_DIR" >/dev/null 2>&1

echo ""
echo "✅ Font installation complete!"
