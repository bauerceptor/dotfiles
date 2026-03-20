# 🐟 Modern Fish Shell Configuration

A clean, fast, and comprehensive Fish shell setup for polyglot development on Fedora 43.

## ✨ Features

- **Minimal Starship prompt** - No version clutter, just what matters
- **Modern CLI replacements** - eza, bat, fd, ripgrep, zoxide, etc.
- **Comprehensive abbreviations** - For Rust, Python, JS/TS, Ruby/Rails, Go, C/C++, SQL
- **Atuin shell history** - Searchable, syncable command history
- **Zoxide navigation** - Smart directory jumping
- **Direnv** - Per-project environment variables
- **FZF integration** - Fuzzy finding for files, history, and git

## 📦 Tools Installed

### Modern Replacements
| Old | New | Purpose |
|-----|-----|---------|
| `ls` | `eza` | Better listing with icons |
| `cat` | `bat` | Syntax highlighting |
| `find` | `fd` | Faster, simpler syntax |
| `grep` | `ripgrep` | Much faster |
| `cd` | `zoxide` | Remembers your directories |
| `du` | `dust` | Visual disk usage |
| `df` | `duf` | Better disk free |
| `top` | `btop` | Beautiful system monitor |
| `ps` | `procs` | Better process list |
| `sed` | `sd` | Easier syntax |
| `curl` | `xh` | Friendlier HTTP client |

### Productivity Tools
- **fzf** - Fuzzy finder
- **atuin** - Shell history
- **delta** - Better git diffs
- **lazygit** - Git TUI
- **starship** - Cross-shell prompt
- **direnv** - Directory environments

## 🚀 Installation

### Step 1: Install modern CLI tools
```bash
# Core tools
sudo dnf install -y fish eza bat fd-find ripgrep fzf zoxide starship \
    direnv atuin delta sd dust duf btop procs hyperfine tealdeer \
    jq yq xh glow lazygit tokei hexyl git gh

# Update tldr cache
tldr --update
```

### Step 2: Copy configuration files

Copy the files to your `.dotfiles` with the correct stow structure:

```bash
# Fish config
mkdir -p ~/.dotfiles/fish/.config/fish/{conf.d,functions}

cp config.fish ~/.dotfiles/fish/.config/fish/
cp fish_plugins ~/.dotfiles/fish/.config/fish/
cp conf.d/abbreviations.fish ~/.dotfiles/fish/.config/fish/conf.d/
cp functions/*.fish ~/.dotfiles/fish/.config/fish/functions/

# Starship config
mkdir -p ~/.dotfiles/starship/.config
cp starship.toml ~/.dotfiles/starship/.config/
```

### Step 3: Stow the configurations
```bash
cd ~/.dotfiles
stow fish
stow starship
```

### Step 4: Install Fisher and plugins
```bash
# Start fish shell
fish

# Install Fisher
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher

# Install plugins from fish_plugins
fisher update
```

### Step 5: Initialize Atuin
```bash
# Import existing history
atuin import auto

# (Optional) Create account for sync
atuin register -u <username> -e <email>
```

## ⌨️ Key Abbreviations

### Navigation
| Abbr | Command |
|------|---------|
| `z` | Smart cd (zoxide) |
| `..` | cd .. |
| `...` | cd ../.. |

### Git
| Abbr | Command |
|------|---------|
| `g` | git |
| `gs` | git status -s |
| `gaa` | git add --all |
| `gc` | git commit -v |
| `gp` | git push |
| `gl` | git pull |
| `lg` | lazygit |

### Development
| Abbr | Command | Lang |
|------|---------|------|
| `c` | cargo | Rust |
| `cr` | cargo run | Rust |
| `ct` | cargo test | Rust |
| `py` | python3 | Python |
| `va` | source .venv/bin/activate.fish | Python |
| `nr` | npm run | Node |
| `prd` | pnpm run dev | Node |
| `r` | bin/rails | Rails |
| `gor` | go run . | Go |

### Docker
| Abbr | Command |
|------|---------|
| `dk` | docker |
| `dco` | docker compose |
| `dcoud` | docker compose up -d |

### System (Fedora)
| Abbr | Command |
|------|---------|
| `dnfi` | sudo dnf install |
| `dnfs` | dnf search |
| `sc` | sudo systemctl |

## 🎹 Key Bindings

| Binding | Action |
|---------|--------|
| `Ctrl+R` | Atuin history search |
| `Ctrl+F` | FZF file search |
| `Ctrl+Alt+F` | FZF git status |
| `Ctrl+Alt+L` | FZF git log |
| `Ctrl+V` | FZF variables |

## 📁 Configuration Locations

| Config | Location |
|--------|----------|
| Fish | `~/.config/fish/` |
| Starship | `~/.config/starship.toml` |
| Atuin | `~/.config/atuin/config.toml` |
| Ripgrep | `~/.config/ripgrep/config` |

## 🔧 Customization

### Add your own abbreviations
Edit `~/.config/fish/conf.d/abbreviations.fish`

### Modify prompt
Edit `~/.config/starship.toml`

### Add project-specific env vars
Create `.envrc` in project directory:
```bash
export DATABASE_URL=postgres://...
export API_KEY=xxx
```
Then run `direnv allow`

## 📖 Tips

1. **Zoxide learns as you go** - Just use `z` instead of `cd` and it builds a database
2. **Abbreviations expand on space** - Type `gs` then space to see `git status -s`
3. **FZF previews** - Use bat for file previews in fzf
4. **Atuin is local by default** - Sync is optional, enable if you want cross-machine history

## 🧹 Cleanup

After confirming everything works, see `CLEANUP.md` for files to remove from your old config.