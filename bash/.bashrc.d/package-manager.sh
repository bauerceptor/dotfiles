#!/bin/bash
# Distro-agnostic package manager aliases

# Detect package manager and create universal aliases
if command -v dnf &>/dev/null; then
    # Fedora/RHEL
    alias pkgi='sudo dnf install'
    alias pkgs='dnf search'
    alias pkgu='sudo dnf upgrade'
    alias pkgr='sudo dnf remove'
    alias pkgl='dnf list installed'
    alias pkginfo='dnf info'
elif command -v apt &>/dev/null; then
    # Debian/Ubuntu
    alias pkgi='sudo apt install'
    alias pkgs='apt search'
    alias pkgu='sudo apt upgrade'
    alias pkgr='sudo apt remove'
    alias pkgl='apt list --installed'
    alias pkginfo='apt show'
elif command -v pacman &>/dev/null; then
    # Arch Linux
    alias pkgi='sudo pacman -S'
    alias pkgs='pacman -Ss'
    alias pkgu='sudo pacman -Syu'
    alias pkgr='sudo pacman -R'
    alias pkgl='pacman -Q'
    alias pkginfo='pacman -Si'
elif command -v zypper &>/dev/null; then
    # openSUSE
    alias pkgi='sudo zypper install'
    alias pkgs='zypper search'
    alias pkgu='sudo zypper update'
    alias pkgr='sudo zypper remove'
    alias pkgl='zypper search --installed-only'
    alias pkginfo='zypper info'
fi
