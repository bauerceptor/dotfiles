# Dotfiles

Modern, cross-platform dotfiles for developers. Supports Linux distributions (Fedora, Ubuntu, Arch) with platform-agnostic configurations.

## ✨ Features

- 🎨 **Centralized Theme System** - One command to change colors across all tools
- 🐧 **Platform Agnostic** - No hardcoded paths, works across Linux distros
- 📦 **Distro Agnostic** - Universal package manager aliases (dnf/apt/pacman)
- ⚙️ **Automated Setup** - Bootstrap script handles everything
- 🔧 **Multiple Editors** - Helix, Zed, VSCode, Neovim (LazyVim)
- 🖥️ **Multiple Terminals** - Alacritty, Ghostty
- 🐚 **Modern Shell** - Fish + Starship prompt + modern CLI tools
- 🎯 **Git Integration** - LazyGit, Delta, Git hooks ready

## 🚀 Quick Start

```bash
# Clone repository
git clone <your-repo-url> ~/.dotfiles
cd ~/.dotfiles

# Bootstrap (install dependencies)
./scripts/bootstrap.sh

# Install dotfiles (stow configs)
./scripts/install.sh

# Check what's installed
./scripts/check-deps.sh
```

## 📂 Structure

```
~/.dotfiles/
├── alacritty/      # Alacritty terminal config
├── bash/           # Bash shell config
├── fish/           # Fish shell config + plugins
├── ghostty/        # Ghostty terminal config
├── helix/          # Helix editor config
├── lazygit/        # LazyGit TUI config
├── lazyvim/        # Neovim (LazyVim) config
├── starship/       # Starship prompt config
├── themes/         # Centralized theme system (coming soon)
├── vscode/         # VS Code config
├── yazi/           # Yazi file manager config
├── zed/            # Zed editor config
├── scripts/        # Installation and utility scripts
└── docs/           # Documentation
```

## 📋 Requirements

### Core Tools
- `git` - Version control
- `stow` - Symlink manager
- `curl` / `wget` - Download tools

### Shell & Prompt
- `fish` - Modern shell
- `starship` - Cross-shell prompt

### Modern CLI Tools
- `eza` - Better ls
- `bat` - Better cat
- `fd` - Better find
- `ripgrep` (rg) - Better grep
- `fzf` - Fuzzy finder
- `zoxide` - Smart cd
- `delta` - Better git diff
- `lazygit` - Git TUI

### Optional Tools
- `atuin` - Shell history
- `direnv` - Per-directory env
- `dust` - Better du
- `duf` - Better df
- `btop` - Better top
- `procs` - Better ps

See [docs/INSTALLATION.md](docs/INSTALLATION.md) for detailed requirements by distro.

## 📖 Documentation

- [Installation Guide](docs/INSTALLATION.md) - Step-by-step installation instructions
- [Usage Guide](docs/USAGE.md) - Common workflows and customization
- [Architecture](docs/ARCHITECTURE.md) - How dotfiles are organized
- [Themes](themes/README.md) - Theme system documentation (coming soon)

## 🔄 Updating

```bash
cd ~/.dotfiles
./scripts/update.sh
```

This will:
1. Pull latest changes from git
2. Restow configurations
3. Update Fish plugins
4. Optionally update fonts

## 🎨 Themes

Theme system coming soon! Will support:
- Automated theme switching across all tools
- Light and dark variants
- Python-based converters for each tool

## 🤝 Platform Support

| Platform | Status | Notes |
|----------|--------|-------|
| Fedora   | ✅ Full | Primary development platform |
| Ubuntu/Debian | ✅ Full | Tested and supported |
| Arch Linux | ✅ Full | Package manager abstraction |
| macOS | ⚠️ Partial | Homebrew paths supported |
| WSL | ⚠️ Partial | Linux tools should work |

## 🛠️ Customization

### Adding Your Own Configs

1. Create a new directory: `mkdir -p ~/.dotfiles/mytool/.config/mytool`
2. Add your config files
3. Add to stow list in `scripts/install.sh`
4. Run `stow mytool` from `~/.dotfiles`

### Package Manager Aliases

Universal aliases work across distros:
- `pkgi <package>` - Install package
- `pkgs <term>` - Search packages
- `pkgu` - Update system
- `pkgr <package>` - Remove package
- `pkgl` - List installed packages

## 📝 License

MIT

## 🙏 Acknowledgments

Built with inspiration from the dotfiles community and modern CLI tools ecosystem.

---

For detailed installation instructions, see [docs/INSTALLATION.md](docs/INSTALLATION.md)
