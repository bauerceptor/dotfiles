# Dotfiles Debian/Fedora Refactor — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make the dotfiles repo idempotent, Debian/Fedora-focused, and fully synced with the current Debian system, while adding missing tool configs and fixing install scripts.

**Architecture:** Keep the existing stow-based package layout. Sync live configs from `~/.config` into the repo as the source of truth. Rewrite scripts to use per-distro package maps, fallback installers, and idempotent checks. Add new stow packages for Rofi, Fuzzel, Kate, Konsole, Dolphin, and Distrobox.

**Tech Stack:** Bash, GNU Stow, Python (theme converters), dnf, apt.

---

## File Structure

### New packages
- `fuzzel/.config/fuzzel/fuzzel.ini`
- `rofi/.config/rofi/config.rasi`
- `rofi/.config/rofi/theme.rasi`
- `kate/.config/katerc`
- `kate/.config/katepartrc`
- `kate/.config/kateschemarc`
- `kate/.config/katesyntaxhighlightingrc`
- `kate/.config/katevirc`
- `kate/.config/kate-externaltoolspluginrc`
- `kate/.config/kate/externaltools/.gitkeep`
- `kate/.config/kate/lspclient/.gitkeep`
- `konsole/.config/konsolerc`
- `konsole/.local/share/konsole/Parrot.profile`
- `konsole/.local/share/konsole/GreenOnBlack.colorscheme`
- `konsole/.local/share/konsole/bookmarks.xml`
- `dolphin/.config/dolphinrc`
- `distrobox/.config/distrobox/distrobox.conf`
- `scripts/distrobox-create.sh`

### Updated packages
- `bash/.bashrc`
- `bash/.bashrc.d/*`
- `fish/.config/fish/*` (excluding `fish_variables`)
- `kitty/.config/kitty/kitty.conf`
- `zed/.config/zed/settings.json`
- `zed/.config/zed/keymap.json`
- `zed/.config/zed/tasks.json`

### Updated scripts
- `scripts/bootstrap.sh`
- `scripts/install.sh`
- `scripts/install-fonts.sh`
- `scripts/update.sh`
- `scripts/check-deps.sh`

### Updated docs
- `README.md`
- `docs/INSTALLATION.md`
- `docs/ARCHITECTURE.md`

### Updated repo metadata
- `.gitignore`

---

## Task 1: Sync Bash config from live system

**Files:**
- Modify: `bash/.bashrc`
- Modify: `bash/.bashrc.d/package-manager.sh`
- Modify: `bash/.bashrc.d/rails.sh`

- [ ] **Step 1: Copy live bash files into repo**

```bash
cp "$HOME/.bashrc" "bash/.bashrc"
mkdir -p "bash/.bashrc.d"
for f in "$HOME/.bashrc.d"/*; do
    [ -f "$f" ] && cp "$f" "bash/.bashrc.d/$(basename "$f")"
done
```

- [ ] **Step 2: Review for non-portable paths**

Run:
```bash
grep -n "/home/red" bash/.bashrc bash/.bashrc.d/* || echo "no hardcoded home paths"
```

Expected: no absolute `/home/red` paths. If any, replace with `$HOME`.

- [ ] **Step 3: Test stow dry-run**

Run:
```bash
cd /home/red/Desktop/dotfiles
stow -n -v bash
```

Expected: shows symlink `~/.bashrc -> dotfiles/bash/.bashrc` and `~/.bashrc.d/*` links.

- [ ] **Step 4: Commit**

```bash
git add bash/
git commit -m "fix(bash): sync live Debian bash config"
```

---

## Task 2: Sync Fish config from live system

**Files:**
- Modify: `fish/.config/fish/config.fish`
- Modify: `fish/.config/fish/conf.d/*`
- Modify: `fish/.config/fish/functions/*`
- Modify: `fish/.config/fish/completions/*`
- Modify: `fish/.config/fish/etc/*`

- [ ] **Step 1: Copy live fish config into repo**

```bash
rsync -av --exclude=fish_variables "$HOME/.config/fish/" "fish/.config/fish/"
```

Expected: all files copied except `fish_variables`.

- [ ] **Step 2: Ensure fish_variables is ignored**

Run:
```bash
grep -q "fish_variables" .gitignore && echo "already ignored" || echo "*.local" >> .gitignore
```

Expected: `.gitignore` contains `fish/.config/fish/fish_variables`.

- [ ] **Step 3: Test stow dry-run**

Run:
```bash
stow -n -v fish
```

Expected: symlinks under `~/.config/fish/` pointing to repo files.

- [ ] **Step 4: Commit**

```bash
git add fish/
git commit -m "fix(fish): sync live Debian fish config"
```

---

## Task 3: Sync Kitty config from live system

**Files:**
- Modify: `kitty/.config/kitty/kitty.conf`
- Delete: `kitty/.config/kitty/*.conf` (old theme files not used on live system)

- [ ] **Step 1: Copy fixed live Kitty config**

```bash
cp "$HOME/.config/kitty/kitty.conf" "kitty/.config/kitty/kitty.conf"
```

- [ ] **Step 2: Verify key settings**

Run:
```bash
grep -n "adjust_line_height\|shell /usr/bin/fish\|font_size" kitty/.config/kitty/kitty.conf
```

Expected:
```
9:font_size 18.0
10:adjust_line_height 3
17:shell /usr/bin/fish
```

- [ ] **Step 3: Remove stale theme files from repo**

```bash
rm -f kitty/.config/kitty/base16-material-palenight.conf \
      kitty/.config/kitty/base16-material-palenight-256.conf \
      kitty/.config/kitty/dracula.conf \
      kitty/.config/kitty/nord.conf \
      kitty/.config/kitty/palenight.conf
```

- [ ] **Step 4: Test stow dry-run**

Run:
```bash
stow -n -v kitty
```

Expected: symlinks `~/.config/kitty/kitty.conf`.

- [ ] **Step 5: Commit**

```bash
git add kitty/
git commit -m "fix(kitty): sync live config, use adjust_line_height 3, remove stale themes"
```

---

## Task 4: Sync Zed config from live system

**Files:**
- Modify: `zed/.config/zed/settings.json`
- Modify: `zed/.config/zed/keymap.json`
- Modify: `zed/.config/zed/tasks.json`
- Delete: `zed/.config/zed/settings_backup.json` if present

- [ ] **Step 1: Copy live Zed config**

```bash
cp "$HOME/.config/zed/settings.json" "zed/.config/zed/settings.json"
cp "$HOME/.config/zed/keymap.json" "zed/.config/zed/keymap.json"
cp "$HOME/.config/zed/tasks.json" "zed/.config/zed/tasks.json"
rm -f "zed/.config/zed/settings_backup.json"
```

- [ ] **Step 2: Verify shell setting**

Run:
```bash
grep -n '"shell"\|"vim_mode"\|"buffer_font_size"' zed/.config/zed/settings.json
```

Expected: `system` or `fish` for shell, `vim_mode: false`, `buffer_font_size: 22`.

- [ ] **Step 3: Test stow dry-run**

Run:
```bash
stow -n -v zed
```

Expected: symlinks under `~/.config/zed/`.

- [ ] **Step 4: Commit**

```bash
git add zed/
git commit -m "fix(zed): sync live Debian zed config"
```

---

## Task 5: Add Fuzzel config

**Files:**
- Create: `fuzzel/.config/fuzzel/fuzzel.ini`

- [ ] **Step 1: Create fuzzel package directory and copy config**

```bash
mkdir -p "fuzzel/.config/fuzzel"
cp "$HOME/.config/fuzzel/fuzzel.ini" "fuzzel/.config/fuzzel/fuzzel.ini"
```

- [ ] **Step 2: Test stow dry-run**

Run:
```bash
stow -n -v fuzzel
```

Expected: symlink `~/.config/fuzzel/fuzzel.ini`.

- [ ] **Step 3: Commit**

```bash
git add fuzzel/
git commit -m "feat(fuzzel): add fuzzel config synced from live system"
```

---

## Task 6: Create Rofi hybrid config

**Files:**
- Create: `rofi/.config/rofi/config.rasi`
- Create: `rofi/.config/rofi/theme.rasi`

- [ ] **Step 1: Create rofi package directory**

```bash
mkdir -p "rofi/.config/rofi"
```

- [ ] **Step 2: Write config.rasi**

Create `rofi/.config/rofi/config.rasi`:

```rasi
configuration {
    modi: "drun,run,window,filebrowser";
    show-icons: true;
    icon-theme: "Papirus";
    terminal: "kitty";
    drun-display-format: "{name}";
    location: 0;
    disable-history: false;
    hide-scrollbar: true;
    display-drun: "  Apps  ";
    display-run: "  Run  ";
    display-window: "  Window  ";
    display-filebrowser: "  Files  ";
    sidebar-mode: true;
}

@theme "theme"
```

- [ ] **Step 3: Write theme.rasi**

Create `rofi/.config/rofi/theme.rasi`:

```rasi
* {
    bg: #101014;
    bg-alt: #16161e;
    fg: #a9b1d6;
    fg-alt: #787c99;
    green: #73daca;
    blue: #7aa2f7;
    red: #f7768e;
    yellow: #e0af68;

    background-color: @bg;
    text-color: @fg;
    font: "JetBrainsMono Nerd Font 12";
}

window {
    width: 45%;
    height: 55%;
    border: 2px;
    border-color: @green;
    border-radius: 12px;
    background-color: @bg;
    padding: 20px;
}

mainbox {
    background-color: transparent;
    children: [inputbar, listview, mode-switcher];
    spacing: 15px;
}

inputbar {
    background-color: @bg-alt;
    border-radius: 8px;
    padding: 12px;
    children: [prompt, entry];
    spacing: 10px;
}

prompt {
    background-color: transparent;
    text-color: @green;
}

entry {
    background-color: transparent;
    text-color: @fg;
    placeholder: "Search...";
    placeholder-color: @fg-alt;
}

listview {
    background-color: transparent;
    columns: 1;
    lines: 8;
    spacing: 6px;
    fixed-height: false;
    dynamic: true;
}

element {
    background-color: transparent;
    padding: 10px;
    border-radius: 6px;
}

element selected {
    background-color: @bg-alt;
    border: 1px;
    border-color: @green;
}

element-icon {
    size: 1.2em;
    background-color: transparent;
}

element-text {
    background-color: transparent;
    text-color: @fg;
}

mode-switcher {
    background-color: transparent;
    spacing: 8px;
}

button {
    background-color: @bg-alt;
    text-color: @fg-alt;
    border-radius: 6px;
    padding: 8px;
}

button selected {
    background-color: @green;
    text-color: @bg;
}
```

- [ ] **Step 4: Test stow dry-run**

Run:
```bash
stow -n -v rofi
```

Expected: symlinks under `~/.config/rofi/`.

- [ ] **Step 5: Commit**

```bash
git add rofi/
git commit -m "feat(rofi): add hybrid rofi launcher config"
```

---

## Task 7: Add Kate, Konsole, and Dolphin configs

**Files:**
- Create: `kate/.config/katerc`
- Create: `kate/.config/katepartrc`
- Create: `kate/.config/kateschemarc`
- Create: `kate/.config/katesyntaxhighlightingrc`
- Create: `kate/.config/katevirc`
- Create: `kate/.config/kate-externaltoolspluginrc`
- Create: `kate/.config/kate/externaltools/.gitkeep`
- Create: `kate/.config/kate/lspclient/.gitkeep`
- Create: `konsole/.config/konsolerc`
- Create: `konsole/.local/share/konsole/Parrot.profile`
- Create: `konsole/.local/share/konsole/GreenOnBlack.colorscheme`
- Create: `konsole/.local/share/konsole/bookmarks.xml`
- Create: `dolphin/.config/dolphinrc`

- [ ] **Step 1: Copy Kate files**

```bash
mkdir -p "kate/.config/kate/externaltools" "kate/.config/kate/lspclient"
for f in "$HOME/.config/katerc" "$HOME/.config/katepartrc" "$HOME/.config/kateschemarc" \
         "$HOME/.config/katesyntaxhighlightingrc" "$HOME/.config/katevirc" \
         "$HOME/.config/kate-externaltoolspluginrc"; do
    [ -f "$f" ] && cp "$f" "kate/.config/$(basename "$f")"
done
touch "kate/.config/kate/externaltools/.gitkeep"
touch "kate/.config/kate/lspclient/.gitkeep"
```

- [ ] **Step 2: Copy Konsole files**

```bash
mkdir -p "konsole/.config" "konsole/.local/share/konsole"
cp "$HOME/.config/konsolerc" "konsole/.config/konsolerc"
cp "$HOME/.local/share/konsole/Parrot.profile" "konsole/.local/share/konsole/Parrot.profile"
cp "$HOME/.local/share/konsole/GreenOnBlack.colorscheme" "konsole/.local/share/konsole/GreenOnBlack.colorscheme"
[ -f "$HOME/.local/share/konsole/bookmarks.xml" ] && \
    cp "$HOME/.local/share/konsole/bookmarks.xml" "konsole/.local/share/konsole/bookmarks.xml"
```

- [ ] **Step 3: Copy Dolphin config**

```bash
mkdir -p "dolphin/.config"
cp "$HOME/.config/dolphinrc" "dolphin/.config/dolphinrc"
```

- [ ] **Step 4: Review for machine-specific paths**

Run:
```bash
grep -R "/home/red" kate/ konsole/ dolphin/ || echo "no hardcoded paths"
```

Expected: no absolute `/home/red` paths.

- [ ] **Step 5: Test stow dry-run**

Run:
```bash
stow -n -v kate konsole dolphin
```

Expected: symlinks to `~/.config/katerc`, `~/.config/konsolerc`, `~/.local/share/konsole/*`, `~/.config/dolphinrc`.

- [ ] **Step 6: Commit**

```bash
git add kate/ konsole/ dolphin/
git commit -m "feat(kde-apps): add kate, konsole, dolphin configs from live system"
```

---

## Task 8: Refactor bootstrap.sh

**Files:**
- Modify: `scripts/bootstrap.sh`

- [ ] **Step 1: Replace bootstrap.sh with distro-aware version**

Write `scripts/bootstrap.sh`:

```bash
#!/bin/bash
# bootstrap.sh - Initial system setup and dependency installation
# Supports Debian/Ubuntu (apt) and Fedora/RHEL (dnf) only.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

# Detect package manager
if command -v dnf &>/dev/null; then
    PKG_MGR="dnf"
    PKG_INSTALL="sudo dnf install -y"
    PKG_EXISTS="rpm -q"
    DISTRO="Fedora/RHEL"
elif command -v apt &>/dev/null; then
    PKG_MGR="apt"
    PKG_INSTALL="sudo apt install -y"
    PKG_EXISTS="dpkg -l"
    DISTRO="Debian/Ubuntu"
else
    echo "❌ Error: No supported package manager found (dnf or apt)"
    exit 1
fi

echo "🚀 Dotfiles Bootstrap Script"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📦 Detected distribution: $DISTRO ($PKG_MGR)"
echo ""

# Check if a package is installed
is_installed() {
    local pkg=$1
    if [ "$PKG_MGR" = "dnf" ]; then
        rpm -q "$pkg" &>/dev/null
    else
        dpkg -l "$pkg" 2>/dev/null | grep -q "^ii"
    fi
}

# Install a package only if missing
install_pkg() {
    local pkg=$1
    if is_installed "$pkg"; then
        echo "  ✓ $pkg already installed, skipping..."
    else
        echo "  → Installing $pkg..."
        $PKG_INSTALL "$pkg"
    fi
}

# Stage 1: Core dependencies
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "1️⃣  Installing core dependencies..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

for pkg in git stow curl wget unzip fontconfig; do
    install_pkg "$pkg"
done

# Stage 2: Offer Homebrew (optional)
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "2️⃣  Homebrew (optional)..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if command -v brew &>/dev/null; then
    echo "✓ Homebrew already installed"
elif [ -d /home/linuxbrew/.linuxbrew ] || [ -d "$HOME/.linuxbrew" ]; then
    echo "✓ Homebrew installation detected"
else
    read -p "Install Homebrew? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        echo "⊙ Skipping Homebrew"
    fi
fi

# Stage 3: Modern CLI tools
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "3️⃣  Installing modern CLI tools..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Tool binary name | dnf package | apt package | fallback function
declare -a TOOLS=(
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

install_eza() {
    if command -v cargo &>/dev/null; then
        cargo install eza
    else
        echo "⚠️  eza fallback failed: cargo not found"
    fi
}

install_zoxide() {
    curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
}

install_starship() {
    curl -sS https://starship.rs/install.sh | sh -s -- -y
}

install_atuin() {
    curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
}

install_delta() {
    local latest
    latest=$(curl -s https://api.github.com/repos/dandavison/delta/releases/latest | grep -oP '"tag_name": "\K[^"]+')
    curl -sSL "https://github.com/dandavison/delta/releases/download/${latest}/delta-${latest}-x86_64-unknown-linux-gnu.tar.gz" | \
        tar xz -C "$HOME/.local/bin" --strip-components=1
}

for entry in "${TOOLS[@]}"; do
    IFS='|' read -r binary dnf_pkg apt_pkg fallback <<< "$entry"
    pkg="$dnf_pkg"
    [ "$PKG_MGR" = "apt" ] && pkg="$apt_pkg"

    if is_installed "$pkg" || command -v "$binary" &>/dev/null; then
        echo "  ✓ $binary already available, skipping..."
        continue
    fi

    if [ -n "$pkg" ] && [ "$pkg" != "$binary" ]; then
        echo "  → Installing $binary ($pkg)..."
        $PKG_INSTALL "$pkg" || {
            if [ -n "${fallback:-}" ]; then
                echo "  ⚠️  Package install failed, trying fallback..."
                $fallback
            fi
        }
    elif [ -n "${fallback:-}" ]; then
        $fallback
    else
        echo "  ⚠️  No install path for $binary"
    fi
done

# Stage 4: Fonts
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "4️⃣  Installing fonts..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

"$REPO_ROOT/scripts/install-fonts.sh"

# Stage 5: Fish shell setup
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "5️⃣  Setting up Fish shell..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if command -v fish &>/dev/null; then
    fish_path=$(command -v fish)
    if ! grep -q "$fish_path" /etc/shells 2>/dev/null; then
        echo "Adding fish to /etc/shells..."
        echo "$fish_path" | sudo tee -a /etc/shells
    fi

    read -p "Set Fish as your default shell? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        chsh -s "$fish_path"
        echo "✓ Default shell changed to Fish (restart required)"
    else
        echo "⊙ Keeping current default shell"
    fi
else
    echo "⚠️  Fish not found"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Bootstrap complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Next steps:"
echo "  1. Run: ./scripts/install.sh"
echo "  2. Restart your terminal"
echo ""
```

- [ ] **Step 2: Make executable and test syntax**

Run:
```bash
chmod +x scripts/bootstrap.sh
bash -n scripts/bootstrap.sh
```

Expected: no syntax errors.

- [ ] **Step 3: Commit**

```bash
git add scripts/bootstrap.sh
git commit -m "refactor(bootstrap): Debian/Fedora-only, per-distro maps, fallbacks"
```

---

## Task 9: Refactor install.sh

**Files:**
- Modify: `scripts/install.sh`

- [ ] **Step 1: Replace install.sh with idempotent stow version**

Write `scripts/install.sh`:

```bash
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

# Stow packages
echo "Stowing configurations..."
for pkg in "${PACKAGES[@]}"; do
    stow_package "$pkg"
done

# LazyVim setup
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Post-install setup..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

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
        echo "  ✓ Fisher already installed, updating plugins..."
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
```

- [ ] **Step 2: Make executable and test syntax**

Run:
```bash
chmod +x scripts/install.sh
bash -n scripts/install.sh
```

Expected: no syntax errors.

- [ ] **Step 3: Commit**

```bash
git add scripts/install.sh
git commit -m "refactor(install): idempotent stow with safe backups and VSCodium support"
```

---

## Task 10: Refactor install-fonts.sh

**Files:**
- Modify: `scripts/install-fonts.sh`

- [ ] **Step 1: Replace install-fonts.sh with minimal version**

Write `scripts/install-fonts.sh`:

```bash
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
    fc-list | grep -qi "$pattern"
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
```

- [ ] **Step 2: Make executable and test syntax**

Run:
```bash
chmod +x scripts/install-fonts.sh
bash -n scripts/install-fonts.sh
```

Expected: no syntax errors.

- [ ] **Step 3: Run twice to verify idempotency**

Run:
```bash
./scripts/install-fonts.sh
./scripts/install-fonts.sh
```

Expected: second run reports both fonts already installed.

- [ ] **Step 4: Commit**

```bash
git add scripts/install-fonts.sh
git commit -m "refactor(fonts): install only JetBrainsMono and Lilex"
```

---

## Task 11: Refactor update.sh

**Files:**
- Modify: `scripts/update.sh`

- [ ] **Step 1: Replace update.sh with path-agnostic version**

Write `scripts/update.sh`:

```bash
#!/bin/bash
# update.sh - Update dotfiles and dependencies

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

echo "🔄 Updating dotfiles..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Pull latest changes
if git rev-parse --git-dir >/dev/null 2>&1; then
    echo "⬇️  Pulling latest changes..."
    git pull || echo "⚠️  git pull failed, continuing..."
else
    echo "⚠️  Not a git repository, skipping pull"
fi

# Re-stow configs
echo ""
echo "🔗 Re-stowing configurations..."
"$REPO_ROOT/scripts/install.sh"

# Update Fish plugins
if command -v fish &>/dev/null && fish -c "functions -q fisher" 2>/dev/null; then
    echo ""
    echo "🐟 Updating Fish plugins..."
    fish -c "fisher update" 2>/dev/null || echo "⚠️  Fisher update failed"
fi

# Optionally update fonts
read -p "Update fonts? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    "$REPO_ROOT/scripts/install-fonts.sh"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Update complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
```

- [ ] **Step 2: Make executable and test syntax**

Run:
```bash
chmod +x scripts/update.sh
bash -n scripts/update.sh
```

Expected: no syntax errors.

- [ ] **Step 3: Commit**

```bash
git add scripts/update.sh
git commit -m "refactor(update): derive repo path from script, resilient stages"
```

---

## Task 12: Refactor check-deps.sh

**Files:**
- Modify: `scripts/check-deps.sh`

- [ ] **Step 1: Replace check-deps.sh with Debian/Fedora version**

Write `scripts/check-deps.sh`:

```bash
#!/bin/bash
# check-deps.sh - Verify installed dependencies

set -euo pipefail

check_binary() {
    local name=$1
    local binary=${2:-$1}
    if command -v "$binary" &>/dev/null; then
        echo "  ✓ $name"
        return 0
    else
        echo "  ✗ $name"
        return 1
    fi
}

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔍 Checking dependencies"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

echo "Core tools:"
CORE_OK=true
for tool in git stow curl wget unzip fc-list fc-cache; do
    check_binary "$tool" || CORE_OK=false
done

echo ""
echo "Modern CLI tools:"
CLI_OK=true
for tool in fish eza bat fd rg fzf zoxide starship direnv atuin delta sd dust duf btop procs hyperfine tldr jq yq xh glow lazygit tokei hexyl gh neovim distrobox zellij; do
    case "$tool" in
        rg) binary="rg" ;;
        tldr) binary="tldr" ;;
        fd) binary="fd" ;;
        gh) binary="gh" ;;
        *) binary="$tool" ;;
    esac
    check_binary "$tool" "$binary" || CLI_OK=false
done

echo ""
echo "Editors:"
EDITORS_OK=true
for tool in nvim helix zed code codium; do
    check_binary "$tool" || EDITORS_OK=false
done

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if [ "$CORE_OK" = false ]; then
    echo "❌ Core tools missing. Run ./scripts/bootstrap.sh"
    exit 1
elif [ "$CLI_OK" = false ] || [ "$EDITORS_OK" = false ]; then
    echo "⚠️  Some optional tools/editors missing. Run ./scripts/bootstrap.sh"
    exit 0
else
    echo "✅ All dependencies present!"
    exit 0
fi
```

- [ ] **Step 2: Make executable and test syntax**

Run:
```bash
chmod +x scripts/check-deps.sh
bash -n scripts/check-deps.sh
./scripts/check-deps.sh
```

Expected: script runs and reports missing/installed tools.

- [ ] **Step 3: Commit**

```bash
git add scripts/check-deps.sh
git commit -m "refactor(check-deps): Debian/Fedora-only checks, add distrobox/zellij"
```

---

## Task 13: Add Distrobox support

**Files:**
- Create: `distrobox/.config/distrobox/distrobox.conf`
- Create: `scripts/distrobox-create.sh`

- [ ] **Step 1: Create distrobox config**

Create `distrobox/.config/distrobox/distrobox.conf`:

```bash
# Distrobox defaults
DBX_CONTAINER_ALWAYS_PULL=0
DBX_CONTAINER_GENERATE_ENTRY=1
DBX_CONTAINER_HOME_PREFIX="$HOME/.containers"
DBX_CONTAINER_INIT_HOOK=""
DBX_CONTAINER_MANAGER="podman"
DBX_EXPORT_PATH="$HOME/.local/bin"
```

- [ ] **Step 2: Create distrobox-create.sh**

Create `scripts/distrobox-create.sh`:

```bash
#!/bin/bash
# distrobox-create.sh - Idempotently create Fedora and Ubuntu containers

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DRY_RUN=false

if [ "${1:-}" = "--dry-run" ]; then
    DRY_RUN=true
    echo "🔍 Dry run mode — no containers will be created"
fi

if ! command -v distrobox &>/dev/null; then
    echo "⚠️  distrobox not installed. Skipping container setup."
    exit 0
fi

if ! command -v podman &>/dev/null && ! command -v docker &>/dev/null; then
    echo "⚠️  No container runtime (podman/docker) found. Skipping container setup."
    exit 0
fi

create_container() {
    local name=$1
    local image=$2

    if distrobox list | grep -q "^$name "; then
        echo "✓ Container '$name' already exists, skipping..."
        return
    fi

    if [ "$DRY_RUN" = true ]; then
        echo "Would create container '$name' from $image"
        return
    fi

    echo "→ Creating container '$name' from $image..."
    distrobox create --name "$name" --image "$image" --yes
}

echo "📦 Setting up Distrobox containers..."
create_container "fedora" "registry.fedoraproject.org/fedora-toolbox:latest"
create_container "ubuntu" "quay.io/toolbx/ubuntu-images:latest"

echo ""
echo "✅ Distrobox setup complete!"
echo "Enter a container with: distrobox enter <name>"
```

- [ ] **Step 3: Make executable and test dry-run**

Run:
```bash
chmod +x scripts/distrobox-create.sh
bash -n scripts/distrobox-create.sh
./scripts/distrobox-create.sh --dry-run
```

Expected: script checks for distrobox/runtime and lists containers it would create.

- [ ] **Step 4: Test stow dry-run for distrobox config**

Run:
```bash
stow -n -v distrobox
```

Expected: symlink `~/.config/distrobox/distrobox.conf`.

- [ ] **Step 5: Commit**

```bash
git add distrobox/ scripts/distrobox-create.sh
git commit -m "feat(distrobox): add config and idempotent Fedora/Ubuntu container helper"
```

---

## Task 14: Update .gitignore

**Files:**
- Modify: `.gitignore`

- [ ] **Step 1: Add font zip ignores**

Append to `.gitignore`:

```gitignore
# Font archives (downloaded on demand)
*.zip
```

- [ ] **Step 2: Stop tracking existing zip files**

Run:
```bash
git rm --cached JetBrainsMono.zip Lilex.zip 2>/dev/null || true
```

Expected: zip files removed from git index but remain on disk.

- [ ] **Step 3: Commit**

```bash
git add .gitignore
git commit -m "chore(gitignore): ignore font zip archives"
```

---

## Task 15: Update README.md

**Files:**
- Modify: `README.md`

- [ ] **Step 1: Remove Arch references and update platform support**

Replace the platform support section in `README.md` with:

```markdown
## 🤝 Platform Support

| Platform | Status | Notes |
|----------|--------|-------|
| Fedora   | ✅ Full | Primary development platform |
| Ubuntu/Debian | ✅ Full | Tested and supported |
| Arch Linux | ❌ Unsupported | Removed to keep scripts maintainable |
| macOS | ⚠️ Partial | Homebrew paths supported but not actively maintained |
| WSL | ⚠️ Partial | Linux tools should work |
```

- [ ] **Step 2: Update package list and directory structure**

Add new directories to the structure diagram:
- `distrobox/`
- `dolphin/`
- `fuzzel/`
- `kate/`
- `konsole/`
- `rofi/`

- [ ] **Step 3: Commit**

```bash
git add README.md
git commit -m "docs(readme): Debian/Fedora focus, add new packages"
```

---

## Task 16: Update docs/INSTALLATION.md

**Files:**
- Modify: `docs/INSTALLATION.md`

- [ ] **Step 1: Remove Arch sections**

Delete any Arch/pacman-specific installation instructions.

- [ ] **Step 2: Add Distrobox note**

Add after the bootstrap section:

```markdown
### Distrobox containers

After installation, you can create the pre-configured Fedora and Ubuntu containers:

```bash
./scripts/distrobox-create.sh
```
```

- [ ] **Step 3: Commit**

```bash
git add docs/INSTALLATION.md
git commit -m "docs(installation): Debian/Fedora only, add distrobox note"
```

---

## Task 17: Update docs/ARCHITECTURE.md

**Files:**
- Modify: `docs/ARCHITECTURE.md`

- [ ] **Step 1: Update directory structure and supported distros**

Add the new packages to the architecture diagram and remove Arch references.

- [ ] **Step 2: Commit**

```bash
git add docs/ARCHITECTURE.md
git commit -m "docs(architecture): add new packages, Debian/Fedora only"
```

---

## Task 18: Final verification

- [ ] **Step 1: Run stow dry-run for all packages**

Run:
```bash
for pkg in alacritty bash distrobox dolphin fish fuzzel ghostty helix kate konsole lazygit lazyvim noctalia rofi starship vscode yazi zed; do
    echo "=== $pkg ==="
    stow -n -v "$pkg" 2>&1 | head -20
done
```

Expected: no conflicts, symlinks point to correct repo paths.

- [ ] **Step 2: Run check-deps.sh**

Run:
```bash
./scripts/check-deps.sh
```

Expected: exits 0 (core tools present). May report optional tools missing.

- [ ] **Step 3: Run install-fonts.sh twice**

Run:
```bash
./scripts/install-fonts.sh
./scripts/install-fonts.sh
```

Expected: second run reports fonts already installed.

- [ ] **Step 4: Review git log**

Run:
```bash
git log --oneline -20
```

Expected: clean commit history with one commit per task.

---

## Self-Review Checklist

- [ ] Spec coverage: every goal from the design spec has at least one task.
- [ ] Placeholder scan: no TODO/TBD/"implement later" in the plan.
- [ ] Type consistency: script variable names and function names match across tasks.
- [ ] Path consistency: all scripts use `$REPO_ROOT` instead of hardcoded `~/.dotfiles`.
- [ ] No stow on current system: verification uses `stow -n -v` only.

---

## Execution Handoff

Plan complete and saved to `docs/superpowers/plans/2026-06-30-dotfiles-debian-fedora-refactor.md`.

**Execution options:**

1. **Subagent-Driven (recommended)** — dispatch a fresh subagent per task, review between tasks.
2. **Inline Execution** — execute tasks in this session with checkpoints.

Which approach would you like?
