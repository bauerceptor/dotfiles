# Dotfiles Debian/Fedora Refactor — Design Spec

**Date:** 2026-06-30  
**Scope:** Make `/home/red/Desktop/dotfiles` idempotent and correct for Debian/Fedora only, sync current Debian system configs into the repo, add missing tool configs, and fix the font/install scripts.

---

## 1. Goals

1. **Idempotency**: Every script must be safe to run repeatedly without errors or duplicate work.
2. **Distro focus**: Support only Debian/Ubuntu (`apt`) and Fedora/RHEL (`dnf`). Remove Arch/pacman code paths.
3. **Config sync**: Current system configs for Bash, Fish, Kitty, Zed, and Fuzzel become the authoritative versions in the repo.
4. **Missing configs**: Add top-level packages for Rofi, Kate, Konsole, Dolphin, and VSCodium compatibility.
5. **Font cleanup**: Install only JetBrainsMono and Lilex fonts; use local `.zip` files when present; add `.zip` files to `.gitignore`.
6. **Better defaults**: Fix package ordering, fallback installers for tools not in `apt`, and hardcoded paths.

---

## 2. Non-Goals

- No full Arch Linux support.
- No macOS-specific fixes beyond what already works.
- No full KDE/Plasma theme snapshot; only per-app configs for Kate, Konsole, and Dolphin.
- No rewriting the theme converter system.
- No switching away from GNU Stow as the default install method.

---

## 3. Architecture

```text
.dotfiles/
├── bash/          ← synced from ~/.bashrc + ~/.bashrc.d
├── fish/          ← synced from ~/.config/fish
├── kitty/         ← synced from ~/.config/kitty
├── zed/           ← synced from ~/.config/zed
├── fuzzel/        ← NEW, synced from ~/.config/fuzzel
├── rofi/          ← NEW, hybrid of reference configs
├── kate/          ← NEW, synced from ~/.config/kate + katerc
├── konsole/       ← NEW, synced from ~/.config/konsolerc + ~/.local/share/konsole
├── dolphin/       ← NEW, synced from ~/.config/dolphinrc
├── vscode/        ← kept, install path supports Code and VSCodium
├── distrobox/     ← NEW, Fedora + Ubuntu container defaults
├── scripts/
│   ├── bootstrap.sh      ← distro-aware, ordered, idempotent installs
│   ├── install.sh        ← idempotent stow with safe backups
│   ├── install-fonts.sh  ← only JetBrainsMono + Lilex
│   ├── update.sh         ← path-agnostic, resilient stages
│   └── check-deps.sh     ← Debian/Fedora-only checks
└── .gitignore     ← ignore *.zip font files
```

### 3.1 Script design

- **`bootstrap.sh`** is the entry point for a fresh system.
  - Stage 1: Detect `dnf` or `apt`; abort on anything else.
  - Stage 2: Install core deps (`git`, `stow`, `curl`, `wget`, `unzip`, `fontconfig`).
  - Stage 3: Optional Homebrew setup (only if the user chooses it; never assumed).
  - Stage 4: Install modern CLI tools using per-distro package maps + fallbacks (includes zellij and distrobox).
  - Stage 5: Install fonts.
  - Stage 6: Offer to set Fish as default shell.
- **`install.sh`** is the config linker.
  - Uses `stow` by default.
  - Backs up existing real files/directories before replacing them.
  - Skips packages already correctly symlinked.
  - Handles special targets: `~/.bashrc`, `~/.config/nvim`, `~/.config/fish`, `~/.config/starship.toml`.
- **`install-fonts.sh`** checks whether JetBrainsMono and Lilex are already registered with `fc-list`. If not, it extracts the local `.zip` files (if present) or downloads them from Nerd Fonts releases. All other font downloads are removed.
- **`update.sh`** derives the repo path from `$0`, pulls, re-stows, updates Fish plugins, and optionally updates fonts.
- **`check-deps.sh`** verifies core, optional, and editor tools, using correct binary/package names for Debian and Fedora.

### 3.2 Package maps

Each CLI tool has a mapping similar to:

```bash
# name: dnf_pkg|apt_pkg|fallback_function
fish|fish|fish_shell_install
```

When `apt_pkg` is empty, the fallback function runs. Examples of fallbacks:
- `eza` on older Debian → install from `eza` GitHub releases or cargo.
- `atuin` → official install script if not packaged.
- `git-delta` on Debian → package `git-delta` when available, otherwise GitHub release.

### 3.3 Config sync rules

- **Bash**: copy current system files wholesale; the live config is the source of truth.
- **Fish**: copy current system files exactly as-is, including `fish_variables`; no style or prompt changes.
- **Kitty**: copy the fixed live `kitty.conf`; ensure `shell /usr/bin/fish` is preserved; use `adjust_line_height 3` (Kitty 0.46+ replaced the obsolete `line_height` key); drop repo-specific theme files if they are not used on the current system.
- **Zed**: copy `settings.json`, `keymap.json`, `tasks.json`.
- **Fuzzel**: new `fuzzel/.config/fuzzel/fuzzel.ini` copied from current system.
- **Rofi**: create a merged config using `leftbar` modes/keybindings and `greenNature` styling, adapted to JetBrainsMono Nerd Font and the current green accent color.
- **Kate/Konsole/Dolphin**: copy the relevant files, preserving the KDE file layout so stow can link them back to the correct paths.
- **VSCode/VSCodium**: keep the existing `vscode/.config/Code/User/*` files; add an install-time copy step for `~/.config/VSCodium/User/` if VSCodium is detected and VS Code is not.

### 3.4 Distrobox setup

- Add `distrobox` to the modern CLI tools list in `bootstrap.sh`.
- Create `distrobox/.config/distrobox/distrobox.conf` with sensible defaults:
  - Export apps and binaries to `~/.local/bin`.
  - Use host's home directory.
  - Pull images from `registry.fedoraproject.org/fedora-toolbox:latest` and `quay.io/toolbx/ubuntu-images:latest`.
- Add `scripts/distrobox-create.sh` to idempotently create `fedora` and `ubuntu` containers:
  - Skip creation if the container already exists.
  - Accept `--dry-run` for safe testing.
  - Optionally enter the container after creation.

---

## 4. Idempotency Rules

Every script must follow these rules:

1. **Check before install**: use `command -v`, `dpkg -l`, `rpm -q`, or `fc-list` before installing.
2. **Check before symlink**: if a symlink already points to the expected repo path, skip.
3. **Backup before replace**: if a real file or directory exists at a target path, move it to `<path>.bak.<timestamp>` before creating a symlink.
4. **No `set -e` cascades**: use `|| true` only where it hides expected failures; for unexpected failures, fail fast but with a clear message.
5. **Idempotent directory creation**: use `mkdir -p` everywhere.
6. **No hardcoded `~/.dotfiles`**: derive the repo root from the script location (`$(cd "$(dirname "$0")/.." && pwd)`).

---

## 5. New & Updated Files

### 5.1 New directories

- `fuzzel/.config/fuzzel/fuzzel.ini`
- `rofi/.config/rofi/config.rasi`
- `rofi/.config/rofi/theme.rasi`
- `kate/.config/katerc`
- `kate/.config/katepartrc`
- `kate/.config/kateschemarc`
- `kate/.config/katesyntaxhighlightingrc`
- `kate/.config/katevirc`
- `kate/.config/kate-externaltoolspluginrc`
- `konsole/.config/konsolerc`
- `konsole/.local/share/konsole/Parrot.profile`
- `konsole/.local/share/konsole/GreenOnBlack.colorscheme`
- `konsole/.local/share/konsole/bookmarks.xml`
- `dolphin/.config/dolphinrc`
- `distrobox/.config/distrobox/distrobox.conf`
- `scripts/distrobox-create.sh` (idempotent helper to create Fedora + Ubuntu containers)

### 5.2 Updated directories

- `bash/`
- `fish/`
- `kitty/`
- `zed/`
- `vscode/` (install logic only)

### 5.3 Updated scripts

- `scripts/bootstrap.sh`
- `scripts/install.sh`
- `scripts/install-fonts.sh`
- `scripts/update.sh`
- `scripts/check-deps.sh`

### 5.4 Updated docs

- `README.md` — remove Arch references, update supported platforms.
- `docs/INSTALLATION.md` — Debian/Fedora only.
- `docs/ARCHITECTURE.md` — update directory list and supported distros.

### 5.5 Updated `.gitignore`

- Add `*.zip` to ignore the font archives.

---

## 6. Fallback Installation Examples

For tools that are not directly available via `apt`:

| Tool | Debian fallback |
|------|-----------------|
| `eza` | GitHub release `.deb` or cargo install |
| `atuin` | Official `curl ... | bash` installer |
| `git-delta` | GitHub release `.deb` if `git-delta` package missing |
| `zoxide` | `curl -sS https://webinstall.dev/zoxide | bash` |
| `starship` | Official install script |
| `fzf` | Git clone + install script |

Fallbacks only run if the tool is not already on `PATH`.

---

## 7. Testing & Verification

1. **Dry-run stow**: `stow -n -v <package>` for every new or changed package.
2. **Dependency check**: `./scripts/check-deps.sh` must exit 0 on the current Debian system.
3. **Font idempotency**: run `./scripts/install-fonts.sh` twice; second run should report both fonts already installed.
4. **Bootstrap dry run**: where possible, run `./scripts/bootstrap.sh` with a flag or commented install commands to verify ordering and detection.
5. **Distrobox**: `scripts/distrobox-create.sh --dry-run` lists the Fedora and Ubuntu containers it would create.

---

## 8. Tool Recommendations to Consider

Based on the current setup and reference configs:

- **Rofi** — adding as top-level launcher (already approved).
- **Walker** — GTK4-based launcher with plugin support.
- **cliphist + wl-clipboard** — clipboard history (referenced in some reference configs).
- **swww / mpvpaper / waypaper** — animated wallpaper support under Wayland.
- **clipse** — terminal clipboard manager.
- **zellij** — terminal multiplexer to add to the install list.
- **atuin / direnv / mise** — already present in the system; keep them.

---

## 9. Risks & Mitigations

| Risk | Mitigation |
|------|------------|
| Copying live KDE configs includes machine-specific paths | Review copied files for absolute usernames/paths and replace with `$HOME` where possible. |
| `apt` package names differ from `dnf` names | Maintain explicit per-distro maps and test on current Debian system. |
| Removing Arch support breaks existing users | Document in README and commit message; Arch users can stay on an older tag. |
| Font `.zip` files already committed to git | Add `.gitignore` and use `git rm --cached` to stop tracking them without deleting local copies. |
| Distrobox requires rootless podman/docker | Check that the container runtime is installed before creating containers; skip gracefully if missing. |
| Stow conflicts on the current system | Do not run `install.sh` on the current system; use `stow -n -v` for verification only. |

---

## 10. Approval

Conversational design approved by user on 2026-06-30. Final written spec pending user review.
