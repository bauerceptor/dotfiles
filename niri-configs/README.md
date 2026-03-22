# Niri Configs

Switch between different niri window manager configurations.

## Quick Start

```bash
# List available profiles
./switch-profile --list

# Switch to a profile (installs packages + applies config)
./switch-profile archyAstronaut

# Show current profile
./switch-profile --current
```

## Profiles

| Profile | Original Author |
|---------|----------------|
| [archyAstronaut](https://github.com/vaelixd/niri-dotfiles) | vaelixd |
| [leftbar](https://github.com/saatvik333/niri-dotfiles) | saatvik333 |
| [pacmanPipes](https://github.com/thenotaryaa/niridots) | thenotaryaa |
| [pcRanIntoProblems](https://github.com/greed-d/.dotfiles) | greed |
| [greenNature](https://github.com/folke/dot) | folke |

## How It Works

1. Each profile directory contains niri-specific configs (waybar, fuzzel, rofi, etc.)
2. Run `./switch-profile <name>` to:
   - Run the profile's install script (installs packages)
   - Symlink configs to `~/.config/`
3. Log out and select niri at login screen

## Requirements

- Fedora 43 (or similar RHEL-based distro)
- Niri installed via COPR

## Notes

- Each profile's install script will prompt for sudo
- Use `--install` flag to only install packages without applying config
