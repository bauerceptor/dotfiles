#!/usr/bin/env bash
# Install packages for archyAstronaut niri profile
# Usage: ./install.sh [--config-only]

set -e

PROFILE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STOW_DIR="$HOME/.dotfiles"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Parse args
CONFIG_ONLY=false
if [ "${1:-}" = "--config-only" ]; then
    CONFIG_ONLY=true
fi

echo "Installing packages for archyAstronaut profile..."

if [ "$EUID" -eq 0 ]; then
    echo -e "${RED}Error: Do not run as root${NC}"
    exit 1
fi

if [ "$CONFIG_ONLY" = false ]; then
    # COPR enable for niri
    if ! dnf copr list 2>/dev/null | grep -q yalter/niri; then
        echo "Enabling COPR: yalter/niri"
        sudo dnf copr enable -y yalter/niri
    fi

    # COPR for niri, hyprlock, and related packages
    if ! dnf copr list 2>/dev/null | grep -q sdegler/hyprland; then
        echo "Enabling COPR: sdegler/hyprland"
        sudo dnf copr enable -y sdegler/hyprland
    fi

    # Packages to install
    PACKAGES=(
        niri
        fuzzel
        waybar
        dunst
        swayidle
        swaybg
        rofi
        kitty
        yazi
        brightnessctl
        hyprlock
    )

    # Only install if not already installed
    echo "Checking packages..."
    TO_INSTALL=()
    for pkg in "${PACKAGES[@]}"; do
        if ! rpm -q "$pkg" &>/dev/null; then
            TO_INSTALL+=("$pkg")
        else
            echo "  ✓ $pkg already installed"
        fi
    done

    if [ ${#TO_INSTALL[@]} -gt 0 ]; then
        echo "Installing: ${TO_INSTALL[*]}"
        sudo dnf install -y "${TO_INSTALL[@]}"
    else
        echo "All packages already installed"
    fi
fi

# Apply configs using stow
echo -e "${YELLOW}Applying configs with stow...${NC}"
cd "$STOW_DIR"
stow -v -t "$HOME" niri-configs

# Link wallpapers
mkdir -p "$HOME/Pictures/Wallpapers"
if [ -d "$PROFILE_DIR/wallpapers" ]; then
    ln -sf "$PROFILE_DIR/wallpapers" "$HOME/Pictures/Wallpapers/archyAstronaut"
    echo "Linked wallpapers"
fi

echo -e "${GREEN}Done!${NC}"
echo "Log out and select niri at login screen."
