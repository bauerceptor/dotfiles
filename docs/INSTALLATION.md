# Installation Guide

Complete step-by-step guide for installing these dotfiles on your system.

## Prerequisites

- A Linux distribution (Fedora, Ubuntu, Debian, Arch, or derivatives)
- `git` installed
- Internet connection

## Quick Installation

```bash
# 1. Clone the repository
git clone <your-repo-url> ~/.dotfiles
cd ~/.dotfiles

# 2. Run bootstrap (installs all dependencies)
./scripts/bootstrap.sh

# 3. Install dotfiles (creates symlinks)
./scripts/install.sh

# 4. Verify installation
./scripts/check-deps.sh
```

## Detailed Installation

### Step 1: Install Git

#### Fedora/RHEL
```bash
sudo dnf install git
```

#### Ubuntu/Debian
```bash
sudo apt install git
```

#### Arch Linux
```bash
sudo pacman -S git
```

### Step 2: Clone Repository

```bash
git clone <your-repo-url> ~/.dotfiles
cd ~/.dotfiles
```

### Step 3: Run Bootstrap Script

The bootstrap script will:
- Detect your Linux distribution
- Install core dependencies (git, stow, curl, wget)
- Install modern CLI tools (eza, bat, ripgrep, etc.)
- Install Nerd Fonts
- Optionally set Fish as default shell

```bash
./scripts/bootstrap.sh
```

**What gets installed:**

**Core Tools:**
- `git` - Version control
- `stow` - Symlink manager
- `curl` / `wget` - Download tools

**Shell & Prompt:**
- `fish` - Modern shell
- `starship` - Cross-shell prompt

**Modern CLI Tools:**
- `eza` - Modern replacement for ls
- `bat` - Cat with syntax highlighting
- `fd` - Fast alternative to find
- `ripgrep` - Fast grep alternative
- `fzf` - Fuzzy finder
- `zoxide` - Smarter cd
- `atuin` - Shell history search
- `direnv` - Per-directory environments
- `git-delta` - Better git diffs
- `sd` - Modern sed alternative
- `dust` - Better du
- `duf` - Better df
- `btop` - System monitor
- `procs` - Better ps
- `hyperfine` - Benchmarking tool
- `tealdeer` (tldr) - Command examples
- `jq` / `yq` - JSON/YAML processors
- `xh` - HTTP client
- `glow` - Markdown renderer
- `lazygit` - Git TUI
- `tokei` - Code statistics
- `hexyl` - Hex viewer
- `gh` - GitHub CLI

### Step 4: Install Dotfiles

This step uses GNU Stow to create symlinks from `~/.dotfiles` to your home directory.

```bash
./scripts/install.sh
```

This will:
1. Stow all configuration packages
2. Install Fish plugins via Fisher
3. Create all necessary symlinks

**What gets linked:**
- `~/.bashrc` → `~/.dotfiles/bash/.bashrc`
- `~/.config/fish/` → `~/.dotfiles/fish/.config/fish/`
- `~/.config/alacritty/` → `~/.dotfiles/alacritty/.config/alacritty/`
- And many more...

### Step 5: Post-Installation

#### Change Default Shell (Optional)

If you want to use Fish as your default shell:

```bash
# Add fish to valid shells
which fish | sudo tee -a /etc/shells

# Change your default shell
chsh -s $(which fish)
```

#### Restart Terminal

Close and reopen your terminal to apply changes.

#### Verify Installation

```bash
cd ~/.dotfiles
./scripts/check-deps.sh
```

This will show which tools are installed and which are missing.

## Distro-Specific Notes

### Fedora

Fedora usually has the most up-to-date packages. Everything should install smoothly.

```bash
# If you want additional repositories
sudo dnf install fedora-workstation-repositories
```

### Ubuntu/Debian

Some tools may need to be installed from alternative sources:

```bash
# Add PPA for newer versions (Ubuntu)
sudo add-apt-repository ppa:fish-shell/release-3
sudo apt update
```

### Arch Linux

Arch has most modern CLI tools in official repos and AUR:

```bash
# Use yay for AUR packages
yay -S <package-name>
```

## Troubleshooting

### Stow Conflicts

If stow reports conflicts (existing files), you have options:

1. **Backup existing files:**
   ```bash
   mkdir -p ~/.dotfiles-backup
   mv ~/.bashrc ~/.dotfiles-backup/
   ```

2. **Force adoption (use with caution):**
   ```bash
   stow --adopt bash
   ```

### Fish Plugins Not Installing

If Fisher doesn't install plugins:

```bash
# Manually install Fisher
fish
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source
fisher install jorgebucaran/fisher

# Then update plugins
fisher update
```

### Command Not Found After Installation

Make sure your PATH is updated:

```bash
# For Bash
source ~/.bashrc

# For Fish
fish
```

### Fonts Not Showing in Terminal

After installing fonts:

1. Refresh font cache: `fc-cache -fv`
2. Restart your terminal
3. In terminal settings, select "JetBrainsMono Nerd Font"

## Uninstallation

To remove dotfiles:

```bash
cd ~/.dotfiles

# Unstow all packages
for dir in */; do
    stow -D "${dir%/}"
done

# Remove the directory
cd ~
rm -rf ~/.dotfiles
```

## Next Steps

- Read [USAGE.md](USAGE.md) for common workflows
- Check [ARCHITECTURE.md](ARCHITECTURE.md) to understand the structure
- Customize your configs in `~/.dotfiles/`

## Getting Help

- Check existing issues in the repository
- Read the documentation in `docs/`
- Run `./scripts/check-deps.sh` to diagnose problems
