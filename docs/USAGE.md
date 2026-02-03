# Usage Guide

Common workflows and customization guide for your dotfiles.

## 🚀 Daily Usage

### Package Management

Universal aliases work on any distro:

```bash
# Install package
pkgi package-name

# Search for package
pkgs search-term

# Update system
pkgu

# Remove package
pkgr package-name

# List installed packages
pkgl
```

### Navigation

```bash
# Smart cd with zoxide
z projects    # Jump to frequently used directory
z doc         # Partial match works too

# Traditional navigation
cd ~/Projects
cd ..         # Go up one directory
cd -          # Go to previous directory
```

### File Operations

```bash
# Modern ls with eza
ls            # List files with icons
ll            # Long format with git status
la            # Show all files including hidden
lt            # Tree view (2 levels)
ltl           # Tree view (3 levels)

# Better cat with bat
cat file.txt  # Syntax highlighting
bathelp       # View with bat (good for man pages)

# Better find with fd
fd pattern    # Find files
fda pattern   # Include hidden files
fdf pattern   # Find files only (no directories)
fdd pattern   # Find directories only

# Better grep with ripgrep
rg pattern    # Search in files
rgi pattern   # Case-insensitive search
rgh pattern   # Include hidden files
```

### Git Workflows

```bash
# LazyGit TUI
lg            # Open LazyGit interface

# Quick commits
g add .
g commit -m "message"
g push

# Check status
gs            # Short status
gst           # Full status

# View logs
glog          # Pretty log graph
gloga         # Include all branches

# Branch management
gb            # List branches
gcb new-branch  # Create and checkout
gsw branch    # Switch to branch
```

## 🎨 Theme Management

### List Available Themes

```bash
cd ~/.dotfiles
./scripts/switch-theme.sh list
```

### Check Current Themes

```bash
./scripts/switch-theme.sh show
```

### Apply Themes

```bash
# Apply to single tool
./scripts/switch-theme.sh sakura-dark alacritty
./scripts/switch-theme.sh nord ghostty

# Apply to all tools
./scripts/switch-theme.sh gruvbox-dark all
```

### Use Different Themes Per Tool

```bash
# Alacritty uses Sakura Dark
./scripts/switch-theme.sh sakura-dark alacritty

# Ghostty uses Nord
./scripts/switch-theme.sh nord ghostty

# Check what you've set
./scripts/switch-theme.sh show
```

## 🔄 Updating Dotfiles

### Pull Latest Changes

```bash
cd ~/.dotfiles
./scripts/update.sh
```

This will:
1. Pull from git
2. Re-stow configs
3. Update Fish plugins
4. Optionally update fonts

### Manual Update

```bash
cd ~/.dotfiles
git pull
stow */        # Restow all packages
```

## ⚙️ Customization

### Edit Configurations

All configs are in `~/.dotfiles/`. Edit them there:

```bash
# Edit Fish config
vim ~/.dotfiles/fish/.config/fish/config.fish

# Edit Starship prompt
vim ~/.dotfiles/starship/.config/starship.toml

# Edit Alacritty
vim ~/.dotfiles/alacritty/.config/alacritty/alacritty.toml
```

Changes are immediately active (configs are symlinked).

### Add Custom Fish Functions

```bash
# Create new function
vim ~/.dotfiles/fish/.config/fish/functions/myfunction.fish

# Use it immediately
myfunction
```

### Add Bash Aliases

```bash
# Edit bashrc
vim ~/.dotfiles/bash/.bashrc

# Or create modular file
vim ~/.dotfiles/bash/.bashrc.d/my-aliases.sh

# Reload
source ~/.bashrc
```

### Add Fish Abbreviations

```bash
# Edit abbreviations file
vim ~/.dotfiles/fish/.config/fish/conf.d/abbreviation.fish

# Add your own:
abbr -a myabbr 'my long command'

# Use it:
myabbr<space>  # Expands to 'my long command'
```

## 🎯 Fish Shell Tips

### Plugin Management

```bash
# List installed plugins
fisher list

# Update all plugins
fisher update

# Install new plugin
fisher install owner/repo

# Remove plugin
fisher remove owner/repo
```

### History Search (Atuin)

```bash
# Search history
Ctrl+R        # Open Atuin search

# Arrow keys use native Fish history
Up/Down       # Previous/next commands
```

### FZF Integration

```bash
# File search
Ctrl+F        # Find files with preview

# Git status
Ctrl+Alt+F    # FZF git status

# Git log
Ctrl+Alt+L    # FZF git log

# Variables
Ctrl+V        # Search shell variables
```

## 🔧 Troubleshooting

### Check Dependencies

```bash
cd ~/.dotfiles
./scripts/check-deps.sh
```

### Stow Conflicts

If stow reports conflicts:

```bash
# See what's conflicting
stow -n -v package-name

# Backup existing file
mv ~/.config/tool/file ~/.config/tool/file.backup

# Try stowing again
stow package-name
```

### Fish Plugins Not Loading

```bash
# Reinstall Fisher
fish
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source
fisher install jorgebucaran/fisher

# Update plugins from fish_plugins file
fisher update

# Verify
fisher list
```

### Shell Not Updating

```bash
# For Bash
source ~/.bashrc

# For Fish
source ~/.config/fish/config.fish
# Or just: exit and reopen terminal
```

### Themes Not Applying

```bash
# Check symlinks
ls -la ~/.config/alacritty/colors.toml
ls -la ~/.config/ghostty/theme-active

# Ensure your config imports them
# See themes/README.md for details

# Restart terminal
```

## 🆘 Getting Help

### Built-in Help

```bash
# Modern tools have great help
bat --help
eza --help
fd --help
rg --help

# Or use tldr for examples
tldr bat
tldr eza
```

### Check Logs

```bash
# Fish shell errors
fish -d 3  # Debug mode

# Check file permissions
ls -la ~/.config/

# Verify symlinks
ls -la ~/.config/fish/
ls -la ~/.bashrc
```

## 💡 Pro Tips

### 1. Use Abbreviations

Fish abbreviations expand when you press space:
```bash
g<space>      → git
gs<space>     → git status -s
gaa<space>    → git add --all
```

### 2. Smart Directory Jumping

After using directories, zoxide learns:
```bash
z proj        # Jumps to ~/Projects
z dot         # Jumps to ~/.dotfiles
z conf        # Jumps to ~/.config
```

### 3. Quick Previews

```bash
# Preview files with bat
bat file.txt

# Tree view with icons
lt

# Preview git changes
gd  # Uses delta for better diffs
```

### 4. Fuzzy Finding

```bash
# Find and edit file
vim $(fd pattern | fzf)

# Find and cd
cd $(fd -t d | fzf)

# Search history
history | fzf
```

### 5. LazyGit Workflow

```bash
lg              # Open LazyGit
# Then:
# Space = Stage/Unstage
# c = Commit
# P = Push
# p = Pull
# ? = Help
```

## 📚 Learning Resources

### Tools
- [Fish Shell Tutorial](https://fishshell.com/docs/current/tutorial.html)
- [Starship Configuration](https://starship.rs/config/)
- [LazyGit Keybindings](https://github.com/jesseduffield/lazygit#keybindings)

### Modern CLI Tools
- [eza](https://github.com/eza-community/eza)
- [bat](https://github.com/sharkdp/bat)
- [ripgrep](https://github.com/BurntSushi/ripgrep)
- [fd](https://github.com/sharkdp/fd)
- [zoxide](https://github.com/ajeetdsouza/zoxide)
- [delta](https://github.com/dandavison/delta)

---

For installation help, see [INSTALLATION.md](INSTALLATION.md)

For architecture details, see [ARCHITECTURE.md](ARCHITECTURE.md)
