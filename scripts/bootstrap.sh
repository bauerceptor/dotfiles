#!/bin/bash
# bootstrap.sh - Initial system setup and dependency installation
# Debian/Fedora-only, idempotent bootstrap with per-distro package maps.

set -euo pipefail

echo "🚀 Dotfiles Bootstrap Script"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
readonly REPO_ROOT

# Detect package manager
if command -v dnf &>/dev/null; then
    PKG_MGR="dnf"
    PKG_INSTALL="sudo dnf install -y"
    PKG_EXISTS="rpm -q"
    DISTRO="Fedora/RHEL"
elif command -v apt &>/dev/null; then
    PKG_MGR="apt"
    PKG_INSTALL="sudo apt install -y"
    PKG_EXISTS="dpkg-query -W -f='${Status}'"
    DISTRO="Debian/Ubuntu"
else
    echo "❌ Error: No supported package manager found (dnf or apt required)" >&2
    exit 1
fi

echo "📦 Detected distribution: $DISTRO ($PKG_MGR)"
echo ""

is_command() {
    command -v "$1" &>/dev/null
}

package_installed() {
    local pkg=$1
    if [ "$PKG_MGR" = "dnf" ]; then
        $PKG_EXISTS "$pkg" >/dev/null 2>&1
    else
        $PKG_EXISTS "$pkg" 2>/dev/null | grep -q "install ok installed"
    fi
}

install_package() {
    local pkg=$1
    echo "  → Installing $pkg via $PKG_MGR..."
    $PKG_INSTALL "$pkg"
}

install_core_dep() {
    local pkg=$1
    if package_installed "$pkg" || is_command "$pkg"; then
        echo "  ✓ $pkg already installed, skipping..."
    else
        install_package "$pkg"
    fi
}

# Core dependencies
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "1️⃣  Installing core dependencies..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

for pkg in git stow curl wget unzip fontconfig; do
    install_core_dep "$pkg"
done

# Optional Homebrew
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "2️⃣  Optional Homebrew install..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

read -rp "Install Homebrew? (y/N): " brew_reply || true
if [[ ${brew_reply:-} =~ ^[Yy]$ ]]; then
    if is_command brew; then
        echo "  ✓ Homebrew already installed, skipping..."
    else
        echo "  → Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
else
    echo "  ⊙ Skipping Homebrew install"
fi

# Modern CLI tools
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "3️⃣  Installing modern CLI tools..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

install_eza() {
    if is_command cargo; then
        echo "  → Installing eza via cargo..."
        cargo install eza
    else
        echo "  ⚠️ cargo not found; skipping eza fallback install" >&2
        return 1
    fi
}

install_zoxide() {
    echo "  → Installing zoxide via upstream installer..."
    curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
}

install_starship() {
    echo "  → Installing starship via upstream installer..."
    curl -sS https://starship.rs/install.sh | sh -s -- -y
}

install_atuin() {
    echo "  → Installing atuin via upstream installer..."
    curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
}

install_delta() {
    echo "  → Installing delta via GitHub release..."
    local tmpdir
    tmpdir="$(mktemp -d)"
    trap 'rm -rf "$tmpdir"' RETURN

    local arch
    arch="$(uname -m)"
    local os="unknown-linux-gnu"
    local asset
    case "$arch" in
        x86_64)
            asset="delta-x86_64-${os}.tar.gz"
            ;;
        aarch64|arm64)
            asset="delta-aarch64-${os}.tar.gz"
            ;;
        *)
            echo "  ⚠️ Unsupported architecture: $arch; skipping delta fallback" >&2
            return 1
            ;;
    esac

    local latest_url="https://github.com/dandavison/delta/releases/latest/download/${asset}"
    local tarball="${tmpdir}/${asset}"

    curl -fsSL "$latest_url" -o "$tarball"
    tar -xzf "$tarball" -C "$tmpdir"

    mkdir -p "$HOME/.local/bin"
    find "$tmpdir" -name delta -type f -exec cp -f {} "$HOME/.local/bin/delta" \;
    chmod +x "$HOME/.local/bin/delta"
}

install_tool() {
    local binary=$1 dnf_pkg=$2 apt_pkg=$3 fallback_name=${4:-}

    local pkg
    if [ "$PKG_MGR" = "dnf" ]; then
        pkg="$dnf_pkg"
    else
        pkg="$apt_pkg"
    fi

    if is_command "$binary"; then
        echo "  ✓ $binary already installed, skipping..."
        return 0
    fi

    if package_installed "$pkg"; then
        echo "  ✓ $pkg already installed, skipping..."
        return 0
    fi

    echo "  → $binary is missing, installing $pkg..."
    if install_package "$pkg"; then
        return 0
    fi

    if [ -n "$fallback_name" ]; then
        echo "  ⚠️ Package install failed, trying fallback: $fallback_name"
        if ! "$fallback_name"; then
            echo "  ⚠️ Fallback $fallback_name failed for $binary" >&2
            return 1
        fi
    else
        echo "  ⚠️ Failed to install $binary and no fallback available" >&2
        return 1
    fi
}

tools=(
    "fish|fish|fish"
    "eza|eza|eza|install_eza"
    "bat|bat|bat"
    "fd|fd-find|fd-find"
    "rg|ripgrep|ripgrep"
    "fzf|fzf|fzf"
    "zoxide|zoxide|zoxide|install_zoxide"
    "starship|starship|starship|install_starship"
    "direnv|direnv|direnv"
    "atuin|atuin|atuin|install_atuin"
    "delta|git-delta|git-delta|install_delta"
    "sd|sd|sd"
    "dust|dust|dust"
    "duf|duf|duf"
    "btop|btop|btop"
    "procs|procs|procs"
    "hyperfine|hyperfine|hyperfine"
    "tldr|tealdeer|tealdeer"
    "jq|jq|jq"
    "yq|yq|yq"
    "xh|xh|xh"
    "glow|glow|glow"
    "lazygit|lazygit|lazygit"
    "tokei|tokei|tokei"
    "hexyl|hexyl|hexyl"
    "gh|gh|gh"
    "neovim|neovim|neovim"
    "distrobox|distrobox|distrobox"
    "zellij|zellij|zellij"
)

for entry in "${tools[@]}"; do
    IFS='|' read -r binary dnf_pkg apt_pkg fallback_name <<< "$entry"
    install_tool "$binary" "$dnf_pkg" "$apt_pkg" "$fallback_name"
done

# Fish shell setup
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "4️⃣  Setting up Fish shell..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if is_command fish; then
    fish_path="$(command -v fish)"
    readonly fish_path

    if ! grep -qFx "$fish_path" /etc/shells 2>/dev/null; then
        echo "  → Adding fish to /etc/shells..."
        echo "$fish_path" | sudo tee -a /etc/shells >/dev/null
    else
        echo "  ✓ fish already in /etc/shells"
    fi

    echo ""
    read -rp "Set Fish as your default shell? (y/N): " shell_reply || true
    if [[ ${shell_reply:-} =~ ^[Yy]$ ]]; then
        chsh -s "$fish_path"
        echo "  ✓ Default shell changed to Fish (restart required)"
    else
        echo "  ⊙ Keeping current default shell"
    fi
else
    echo "  ⚠️ fish not found, skipping shell setup"
fi

# Install fonts
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "5️⃣  Installing Nerd Fonts..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

"$REPO_ROOT/scripts/install-fonts.sh"

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
