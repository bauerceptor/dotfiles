# Ansible Packages

Declarative, idempotent package installation for developers using Ansible.

## Why Ansible?

- **Idempotent**: Run multiple times without side effects
- **Declarative**: Specify what you want, not how to install it
- **Reproducible**: Same results on any machine
- **Conditional**: Skip packages you don't need

## Quick Start

```bash
# 1. Install ansible (one-time)
./scripts/install-ansible.sh

# 2. Run playbooks
cd ansible

# Install everything (use -K to prompt for sudo password if needed)
ansible-playbook -i hosts main.yml other.yml dnf.yml --become -K

# Or install selectively
ansible-playbook -i hosts main.yml --become -K          # Core tools only
ansible-playbook -i hosts other.yml --become -K         # curl|sh, uvx, brew tools
ansible-playbook -i hosts dnf.yml --become -K           # DNF-specific (Fedora/RHEL)
```

**Note:** The `-K` flag prompts for your sudo password. If you have passwordless sudo configured, you can omit it.

## Playbooks

### main.yml
Core system tools and Homebrew.

| Package | Description |
|---------|-------------|
| git | Version control |
| stow | Symlink manager |
| curl | Download tool |
| wget | Download tool |
| bash-completion | Bash completions |
| Homebrew | Package manager (macOS/Linux) |

**Tags**: `main`, `core`, `brew`, `all`

### other.yml
Tools installed via curl|sh, uvx, and Homebrew.

| Package | Install Method | Description |
|---------|---------------|-------------|
| mise | curl\|sh | Runtime version manager |
| uv | curl\|sh | Python package manager |
| lazygit | curl\|sh | Git TUI |
| lazydocker | curl\|sh | Docker TUI |
| dust | curl\|sh | du alternative |
| zoxide | curl\|sh | cd alternative |
| direnv | curl\|sh | Per-directory env |
| croc | curl\|sh | File transfer |
| xh | curl\|sh | HTTP client |
| dog | curl\|sh | DNS lookup |
| fx | curl\|sh | JSON viewer |
| cheat | wget | CLI cheat sheets |
| lnav | curl\|sh | Log viewer |
| angle-grinder | brew | Log analytics |
| atuin | curl\|sh | Shell history |
| distrobox | curl\|sh | Container wrapper |
| minikube | curl\|sh | Kubernetes |
| zed | curl\|sh | Code editor |
| soar | curl\|sh | SQL query analyzer |
| claude | curl\|sh | AI CLI |
| opencode | curl\|sh | Code editor |
| pnpm | curl\|sh | Package manager |
| glances | uvx | System monitor |
| curlie | curl\|sh | HTTP client |
| fnm | curl\|sh | Node version manager |
| jc | uvx | JSON convert |
| pgcli | uvx | Postgres CLI |
| broot | brew | tree alternative |
| glow | brew | Markdown viewer |
| sd | brew | sed alternative |
| yazi | brew | File manager |
| magic-wormhole | brew | File transfer |
| k9s | brew | Kubernetes terminal UI |
| gron | brew | JSON grep |
| fzf | brew | Fuzzy finder |
| yq | brew | YAML processor |
| dockly | brew | Docker TUI |

**Tags**: `other`, `curl`, `uvx`, `brew`, `all`

### dnf.yml
DNF-specific packages (Fedora/RHEL only).

| Package | Description |
|---------|-------------|
| helix | Editor |
| bat | cat alternative |
| git-delta | Better diff |
| duf | df alternative |
| fd-find | find alternative |
| ripgrep | grep alternative |
| hyperfine | Benchmarking |
| procs | ps alternative |
| httpie | HTTP client |
| mosh | SSH alternative |
| plocate | locate alternative |
| hexyl | hexdump alternative |
| rust-tealdeer | tldr alternative |
| python3-dnf-plugin-versionlock | DNF version lock |
| ghostty | Terminal |
| eza | ls alternative |
| difftastic | diff alternative |
| choose | cut alternative |
| podman-docker | Docker compatibility |
| podman-compose | Docker Compose |

**Tags**: `dnf`, `fedora`, `rhel`

## Usage Examples

### Install specific tags

```bash
# Only Homebrew tools
ansible-playbook main.yml --tags "brew" --become

# Only curl|sh tools
ansible-playbook other.yml --tags "curl" --become

# (cargo tag removed - no cargo tools)

# Only uvx tools
ansible-playbook other.yml --tags "uvx" --become
```

### Skip specific packages

```bash
# Skip Homebrew using tags
ansible-playbook main.yml --tags "core" --become

# Skip brew using tags
ansible-playbook other.yml --tags "curl,uvx,brew" --become
```

### Use custom inventory

```bash
# Create custom inventory with different settings
cp inventory.yml inventory custom.yml

# Edit custom.yml to disable packages
# Set install_brew: false
# Set install_lazygit: false

# Run with custom inventory
ansible-playbook main.yml other.yml -i custom.yml --become
```

### Run as non-root (without --become)

Some packages can be installed without sudo:

```bash
# Core tools require sudo
ansible-playbook main.yml --become

# Other tools can be installed without sudo (user space)
ansible-playbook other.yml
```

## Package Selection

Edit `inventory.yml` to enable/disable packages:

```yaml
all:
  vars:
    # Disable Homebrew
    install_brew: false

    # Disable brew tools
    install_difftastic: false
    install_broot: false
    install_choose: false
```

## Requirements

- Ansible installed: `./scripts/install-ansible.sh`
- For DNF packages: Fedora/RHEL or DNF-based distro
- For Homebrew: macOS or Linux with Homebrew installed

## Troubleshooting

### "pkgi alias not found"

Source your shell config first:
```bash
source ~/.bashrc  # for Bash
# or restart Fish shell
```

### "No DNF-specific packages available"

The `dnf.yml` playbook only runs on RedHat-based systems. It will be skipped on other distributions.

### Check what's installed

```bash
# List installed packages
ansible-playbook main.yml --list-tasks
ansible-playbook other.yml --list-tasks

# Dry run
ansible-playbook main.yml --check --become
```

## File Structure

```
ansible/
├── README.md           # This file
├── hosts              # Inventory file (localhost)
├── main.yml           # Core tools
├── other.yml          # curl|sh, uvx, brew tools
├── dnf.yml           # DNF-specific packages
└── inventory.yml     # Configuration variables
```

## Contributing

To add new packages:

1. Edit the appropriate YAML file
2. Add the package with proper idempotency check:
   - Use `creates` parameter for shell commands
   - Use `when` condition for package module
3. Add variable to `inventory.yml`
4. Update this README
