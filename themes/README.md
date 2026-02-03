# Centralized Theme System

Flexible theme management for your dotfiles. Apply different themes to different tools independently.

## 🎨 Features

- **Per-Tool Themes** - Each tool can have its own theme
- **Central Palette** - Define colors once, generate for multiple tools
- **Easy Switching** - One command to change themes
- **Preserved Configs** - Your current themes stay untouched until you apply a new one
- **Automated Conversion** - Python scripts generate tool-specific configs

## 📂 Structure

```
themes/
├── schemes/          # Theme palette definitions (TOML)
│   ├── sakura-dark.toml
│   ├── sakura-light.toml
│   ├── nord.toml
│   └── gruvbox-dark.toml
├── converters/       # Python scripts to convert palettes
│   ├── to_alacritty.py
│   └── to_ghostty.py
├── generated/        # Auto-generated theme configs (don't edit)
└── README.md         # This file
```

## 🚀 Quick Start

### List Available Themes

```bash
cd ~/.dotfiles
./scripts/switch-theme.sh list
```

### Show Current Themes

```bash
./scripts/switch-theme.sh show
```

### Apply Theme to Specific Tool

```bash
# Apply to Alacritty only
./scripts/switch-theme.sh sakura-dark alacritty

# Apply to Ghostty only
./scripts/switch-theme.sh nord ghostty

# Apply to all tools
./scripts/switch-theme.sh gruvbox-dark all
```

## 📖 Usage Examples

### Keep Different Themes for Each Tool

```bash
# Set Alacritty to Sakura Dark
./scripts/switch-theme.sh sakura-dark alacritty

# Set Ghostty to Nord
./scripts/switch-theme.sh nord ghostty

# Now Alacritty uses Sakura and Ghostty uses Nord!
```

### Switch One Tool's Theme

```bash
# Change only Alacritty
./scripts/switch-theme.sh gruvbox-dark alacritty

# Ghostty keeps its previous theme (Nord)
```

### Apply Same Theme to All

```bash
# Set all tools to the same theme
./scripts/switch-theme.sh nord all
```

## 🎨 Available Themes

### Custom Themes

**Sakura Dark**
- Soft cherry blossom pinks, gentle and dreamy
- **Variant:** Dark
- **Colors:** Pink accents, dark purple background

**Sakura Light**
- Daytime cherry blossom, soft and airy
- **Variant:** Light
- **Colors:** Soft pinks, light background

### Popular Community Themes

**Catppuccin Mocha** 🌸
- Soothing pastel theme - Darkest variant
- **Variant:** Dark
- **Preview:** https://catppuccin.com/palette
- **GitHub:** https://github.com/catppuccin/catppuccin

**Catppuccin Macchiato** ☕
- Soothing pastel theme - Medium dark variant
- **Variant:** Dark
- **Preview:** https://catppuccin.com/palette

**Catppuccin Latte** ☀️
- Soothing pastel theme - Light variant
- **Variant:** Light
- **Preview:** https://catppuccin.com/palette

**Dracula** 🧛
- A dark theme with vibrant colors
- **Variant:** Dark
- **Preview:** https://draculatheme.com/
- **GitHub:** https://draculatheme.com/contribute

**Tokyo Night** 🏙️
- Clean dark theme inspired by Tokyo city lights
- **Variant:** Dark
- **Preview:** https://github.com/enkia/tokyo-night-vscode-theme#screenshots

**Tokyo Night Storm** ⛈️
- Tokyo Night theme - Storm variant (lighter)
- **Variant:** Dark
- **Preview:** https://github.com/enkia/tokyo-night-vscode-theme#screenshots

**One Dark** ⚫
- Atom's iconic One Dark theme
- **Variant:** Dark
- **Preview:** https://github.com/atom/atom/tree/master/packages/one-dark-syntax

**Solarized Dark** 🌓
- Precision colors for machines and people
- **Variant:** Dark
- **Preview:** https://ethanschoonover.com/solarized/
- **GitHub:** https://github.com/altercation/solarized

**Solarized Light** ☀️
- Precision colors - Light variant
- **Variant:** Light
- **Preview:** https://ethanschoonover.com/solarized/

**Monokai Pro** 💼
- Professional theme with warm colors
- **Variant:** Dark
- **Preview:** https://monokai.pro/

**Nord** ❄️
- Arctic, north-bluish color palette
- **Variant:** Dark
- **Preview:** https://www.nordtheme.com/

**Gruvbox Dark** 🟤
- Retro groove color scheme
- **Variant:** Dark
- **Preview:** https://github.com/morhetz/gruvbox

## 🛠️ Creating Your Own Theme

### 1. Create a Palette File

Create `themes/schemes/mytheme.toml`:

```toml
[meta]
name = "My Theme"
variant = "dark"  # or "light"
description = "My custom theme description"

[colors.base]
background = "#1a1a1a"
foreground = "#e0e0e0"
cursor = "#00ff00"
selection_bg = "#444444"
selection_fg = "#ffffff"

[colors.ansi]
black = "#1a1a1a"
red = "#ff5555"
green = "#50fa7b"
yellow = "#f1fa8c"
blue = "#bd93f9"
magenta = "#ff79c6"
cyan = "#8be9fd"
white = "#f8f8f2"

[colors.bright]
black = "#6272a4"
red = "#ff6e6e"
green = "#69ff94"
yellow = "#ffffa5"
blue = "#d6acff"
magenta = "#ff92df"
cyan = "#a4ffff"
white = "#ffffff"

[colors.semantic]
error = "#ff5555"
warning = "#f1fa8c"
success = "#50fa7b"
info = "#bd93f9"
```

### 2. Apply Your Theme

```bash
./scripts/switch-theme.sh mytheme alacritty
```

## 🔧 How It Works

1. **Central Palette** - Colors defined in `schemes/*.toml`
2. **Converters** - Python scripts read palette and generate tool configs
3. **Generated Configs** - Tool-specific configs created in `generated/`
4. **Symlinks** - Configs are symlinked to the right locations:
   - `~/.config/alacritty/colors.toml` → `generated/alacritty-mytheme.toml`
   - `~/.config/ghostty/theme-active` → `generated/ghostty-mytheme.toml`

## 📝 Important Notes

### Your Current Themes Are Safe

- **Alacritty**: Your current inline theme in `alacritty.toml` is untouched
- **Ghostty**: Your `kanagawa-dragon` theme is preserved
- **Opt-in System**: Themes only change when you explicitly apply them

### Using Central Themes

To use the central theme system, your tool configs need to import the generated files:

**Alacritty** (`alacritty.toml`):
```toml
# Add this at the end of your config
import = ["~/.config/alacritty/colors.toml"]
```

**Ghostty** (`config`):
```
# Change the theme line to:
theme = theme-active
```

### Reverting to Original Themes

To stop using the central theme system:

**Alacritty:**
```bash
rm ~/.config/alacritty/colors.toml
# Remove the import line from alacritty.toml
```

**Ghostty:**
```bash
rm ~/.config/ghostty/theme-active
# Change theme line back to: theme = kanagawa-dragon
```

## 🆘 Troubleshooting

### Theme Not Applying

1. Check if the symlink exists:
   ```bash
   ls -la ~/.config/alacritty/colors.toml
   ls -la ~/.config/ghostty/theme-active
   ```

2. Verify your config imports the generated file

3. Restart your terminal

### Colors Look Wrong

- Ensure your terminal supports 256 colors
- Check `$TERM` variable: `echo $TERM`
- Should be `xterm-256color` or similar

### Python Errors

- Ensure Python 3.11+ is installed (for `tomllib`)
- Test converter manually:
  ```bash
  python3 themes/converters/to_alacritty.py themes/schemes/sakura-dark.toml
  ```

## 🔮 Future Enhancements

Planned features:
- [ ] Fish shell theme conversion
- [ ] Starship prompt theme conversion
- [ ] Helix editor theme conversion
- [ ] System-aware light/dark mode switching
- [ ] Theme preview before applying
- [ ] More built-in themes

## 📚 Resources

- [Alacritty Color Configuration](https://alacritty.org/config-alacritty.html#colors)
- [Ghostty Theme Documentation](https://ghostty.org/docs/config/reference)
- [Color Scheme Gallery](https://github.com/mbadolato/iTerm2-Color-Schemes)

---

For more information, see the main [README.md](../README.md)
