#!/usr/bin/env bash
# Install packages for leftbar niri profile
# Usage: ./install.sh [--config-only]

set -e

PROFILE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STOW_DIR="$HOME/.dotfiles"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

if [ "${1:-}" = "--config-only" ]; then
    CONFIG_ONLY=true
else
    CONFIG_ONLY=false
fi

echo "Installing packages for leftbar profile..."

if [ "$EUID" -eq 0 ]; then
    echo -e "${RED}Error: Do not run as root${NC}"
    exit 1
fi

if [ "$CONFIG_ONLY" = false ]; then
    # COPR for niri
    if ! dnf copr list 2>/dev/null | grep -q yalter/niri; then
        echo "Enabling COPR: yalter/niri"
        sudo dnf copr enable -y yalter/niri
    fi

    # Note: gtklock is available in Fedora repos

    # Packages based on niri config.kdl
    PACKAGES=(
        niri
        waybar
        gtklock
        mako
        kitty
        yazi
        thunar
        polkit-gnome
    )

    # Only install if not already installed
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

echo -e "${GREEN}Done!${NC}"
echo "Log out and select niri at login screen."
